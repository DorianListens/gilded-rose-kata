require 'gilded_rose'
describe "Gilded Rose" do
  let(:vest) { Item.new("+5 Dexterity Vest", 10, 20) }
  let(:brie) { Item.new("Aged Brie", 2, 0) }
  let(:sulfuras) { Item.new("Sulfuras, Hand of Ragnaros", 0, 80) }
  let(:passes) { Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20) }
  let(:cake) { Item.new("Conjured Mana Cake", 3, 6) }

  it 'Decrements item quality and sell in' do
    update_quality([vest])
    expect(vest[:sell_in]).to eq 9
    expect(vest[:quality]).to eq 19
  end

  it "Decrements item quality twice as fast after the sell by date" do
    vest[:sell_in] = 0
    update_quality([vest])
    expect(vest[:quality]).to eq 18
  end

  it "Does not reduce item quality below zero" do
    vest[:quality] = 0
    update_quality([vest])
    expect(vest[:quality]).to eq 0
  end

  it "Increases the quality of Aged Brie every day" do
    update_quality([brie])
    expect(brie[:quality]).to eq 1
  end

  it "never increases quality above 50" do 
    100.times do
      update_quality([brie])
    end
    expect(brie[:quality]).to eq 50
  end

  it "does not decrease the sell in time or quality of Sulfuras" do
    10.times do
      update_quality([sulfuras])
    end
    expect(sulfuras[:quality]).to eq 80
    expect(sulfuras[:sell_in]).to eq 0
  end

  describe "backstage passes" do
    it "increases in quality by 1 each day while there are more than 10 days left" do
      update_quality([passes])
      expect(passes[:quality]).to eq 21
    end

    it "increases in quality by 2 each day between 10 and 5 days left" do
      passes[:sell_in] = 10
      update_quality([passes])
      expect(passes[:quality]).to eq 22
    end

    it "increases in quality by 3 when there are less than 5 days left" do
      passes[:sell_in] = 5
      update_quality([passes])
      expect(passes[:quality]).to eq 23
    end

    it "reduces quality to zero when there are 0 days left" do
      passes[:sell_in] = 0
      update_quality([passes])
      expect(passes[:quality]).to eq 0
    end
  end
  
  describe "Conjoured items" do
    it "degrades in quality twice as fast as regular items" do
      update_quality([cake])
      expect(cake.quality).to eq 4
    end

    it "even after the sell by date" do
      cake.sell_in = 0
      update_quality([cake])
      expect(cake.quality).to eq 2
    end
  end
end

require 'rspec/given'

describe "#update_quality" do

  context "with a single" do
    Given(:initial_sell_in) { 5 }
    Given(:initial_quality) { 10 }
    Given(:item) { Item.new(name, initial_sell_in, initial_quality) }

    When { update_quality([item]) }

    context "normal item" do
      Given(:name) { "NORMAL ITEM" }

      Invariant { item.sell_in.should == initial_sell_in-1 }

      context "before sell date" do
        Then { item.quality.should == initial_quality-1 }
      end

      context "on sell date" do
        Given(:initial_sell_in) { 0 }
        Then { item.quality.should == initial_quality-2 }
      end

      context "after sell date" do
        Given(:initial_sell_in) { -10 }
        Then { item.quality.should == initial_quality-2 }
      end

      context "of zero quality" do
        Given(:initial_quality) { 0 }
        Then { item.quality.should == 0 }
      end
    end

    context "Aged Brie" do
      Given(:name) { "Aged Brie" }

      Invariant { item.sell_in.should == initial_sell_in-1 }

      context "before sell date" do
        Then { item.quality.should == initial_quality+1 }

        context "with max quality" do
          Given(:initial_quality) { 50 }
          Then { item.quality.should == initial_quality }
        end
      end

      context "on sell date" do
        Given(:initial_sell_in) { 0 }
        Then { item.quality.should == initial_quality+2 }

        context "near max quality" do
          Given(:initial_quality) { 49 }
          Then { item.quality.should == 50 }
        end

        context "with max quality" do
          Given(:initial_quality) { 50 }
          Then { item.quality.should == initial_quality }
        end
      end

      context "after sell date" do
        Given(:initial_sell_in) { -10 }
        Then { item.quality.should == initial_quality+2 }

        context "with max quality" do
          Given(:initial_quality) { 50 }
          Then { item.quality.should == initial_quality }
        end
      end
    end

    context "Sulfuras" do
      Given(:initial_quality) { 80 }
      Given(:name) { "Sulfuras, Hand of Ragnaros" }

      Invariant { item.sell_in.should == initial_sell_in }

      context "before sell date" do
        Then { item.quality.should == initial_quality }
      end

      context "on sell date" do
        Given(:initial_sell_in) { 0 }
        Then { item.quality.should == initial_quality }
      end

      context "after sell date" do
        Given(:initial_sell_in) { -10 }
        Then { item.quality.should == initial_quality }
      end
    end

    context "Backstage pass" do
      Given(:name) { "Backstage passes to a TAFKAL80ETC concert" }

      Invariant { item.sell_in.should == initial_sell_in-1 }

      context "long before sell date" do
        Given(:initial_sell_in) { 11 }
        Then { item.quality.should == initial_quality+1 }

        context "at max quality" do
          Given(:initial_quality) { 50 }
        end
      end

      context "medium close to sell date (upper bound)" do
        Given(:initial_sell_in) { 10 }
        Then { item.quality.should == initial_quality+2 }

        context "at max quality" do
          Given(:initial_quality) { 50 }
          Then { item.quality.should == initial_quality }
        end
      end

      context "medium close to sell date (lower bound)" do
        Given(:initial_sell_in) { 6 }
        Then { item.quality.should == initial_quality+2 }

        context "at max quality" do
          Given(:initial_quality) { 50 }
          Then { item.quality.should == initial_quality }
        end
      end

      context "very close to sell date (upper bound)" do
        Given(:initial_sell_in) { 5 }
        Then { item.quality.should == initial_quality+3 }

        context "at max quality" do
          Given(:initial_quality) { 50 }
          Then { item.quality.should == initial_quality }
        end
      end

      context "very close to sell date (lower bound)" do
        Given(:initial_sell_in) { 1 }
        Then { item.quality.should == initial_quality+3 }

        context "at max quality" do
          Given(:initial_quality) { 50 }
          Then { item.quality.should == initial_quality }
        end
      end

      context "on sell date" do
        Given(:initial_sell_in) { 0 }
        Then { item.quality.should == 0 }
      end

      context "after sell date" do
        Given(:initial_sell_in) { -10 }
        Then { item.quality.should == 0 }
      end
    end

    context "conjured item" do
      Given(:name) { "Conjured Mana Cake" }

      Invariant { item.sell_in.should == initial_sell_in-1 }

      context "before the sell date" do
        Given(:initial_sell_in) { 5 }
        Then { item.quality.should == initial_quality-2 }

        context "at zero quality" do
          Given(:initial_quality) { 0 }
          Then { item.quality.should == initial_quality }
        end
      end

      context "on sell date" do
        Given(:initial_sell_in) { 0 }
        Then { item.quality.should == initial_quality-4 }

        context "at zero quality" do
          Given(:initial_quality) { 0 }
          Then { item.quality.should == initial_quality }
        end
      end

      context "after sell date" do
        Given(:initial_sell_in) { -10 }
        Then { item.quality.should == initial_quality-4 }

        context "at zero quality" do
          Given(:initial_quality) { 0 }
          Then { item.quality.should == initial_quality }
        end
      end
    end
  end

  context "with several objects" do
    Given(:items) {
      [
        Item.new("NORMAL ITEM", 5, 10),
        Item.new("Aged Brie", 3, 10),
      ]
    }

    When { update_quality(items) }

    Then { items[0].quality.should == 9 }
    Then { items[0].sell_in.should == 4 }

    Then { items[1].quality.should == 11 }
    Then { items[1].sell_in.should == 2 }
  end
end
