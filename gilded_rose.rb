def update_quality(items)
  items.each do |item|
    ItemUpdater.create(item).update
  end
end


class ItemUpdater
  def self.create(item)
    name = item.name
   case
   when /Sulfuras/.match(name)
     return LegendaryItemUpdater.new(item)
   when /Backstage/.match(name)
     return BackstageItemUpdater.new(item)
   when /Aged/.match(name)
     return AgedItemUpdater.new(item)
   when /Conjured/.match(name)
     return ConjuredItemUpdater.new(item)
   else
     return ItemUpdater.new(item)
   end 
  end
  def initialize(item)
    @item = item
  end
  def name
    @item.name
  end
  def quality
    @item.quality
  end
  def sell_in
    @item.sell_in
  end

  def update
    update_sell_in
    update_item_quality
  end

  def update_sell_in
    @item.sell_in -= 1
  end

  def update_item_quality
    if should_reduce_item_quality
      reduce_item_quality
    else
      increase_item_quality
    end
  end

  def should_reduce_item_quality
    true
  end

  def reduce_item_quality
    if quality > 0
      @item.quality -= amount_to_reduce_quality_by
    end
  end

  def increase_item_quality
    if quality < 50
      @item.quality += amount_to_increase_quality_by
    end
  end

  def amount_to_increase_quality_by
    1
  end
  
  def amount_to_reduce_quality_by
    if sell_in > 0
      1
    else
      2
    end
  end
end

class LegendaryItemUpdater < ItemUpdater
  def update_sell_in
  end

  def should_reduce_item_quality
    false
  end
end

class AgedItemUpdater < ItemUpdater
  def amount_to_increase_quality_by
    if sell_in < 0
      2
    else
      1
    end
  end

  def should_reduce_item_quality
    false
  end
end

class BackstageItemUpdater < ItemUpdater
  def amount_to_increase_quality_by
    if (6..11).cover?(sell_in)
      2
    elsif sell_in < 6
      3
    else
      1
    end
  end

  def should_reduce_item_quality
    sell_in < 0
  end

  def amount_to_reduce_quality_by
    quality
  end
end

class ConjuredItemUpdater < ItemUpdater
  def amount_to_reduce_quality_by
    super * 2
  end
end
# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

