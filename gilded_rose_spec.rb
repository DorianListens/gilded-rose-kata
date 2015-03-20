require 'gilded_rose'
describe "Gilded Rose" do
  Items = [
    Item.new("+5 Dexterity Vest", 10, 20),
    Item.new("Aged Brie", 2, 0),
    Item.new("Elixir of the Mongoose", 5, 7),
    Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
    Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
    Item.new("Conjured Mana Cake", 3, 6),
  ]
  let(:items) {Items}
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
