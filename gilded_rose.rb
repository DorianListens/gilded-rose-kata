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
    if name != 'Sulfuras, Hand of Ragnaros'
      @item.sell_in -= 1
    end
  end

  def update_item_quality
    if should_reduce_item_quality
      reduce_item_quality
    else
      increase_item_quality
    end
  end

  def should_reduce_item_quality
    case
    when name === 'Aged Brie' || name === 'Sulfuras, Hand of Ragnaros'
      return false
    when name === 'Backstage passes to a TAFKAL80ETC concert'
      if sell_in > 0
        return false
      else
        return true
      end
    else
      return true
    end
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
    amount = 1
    if name == 'Backstage passes to a TAFKAL80ETC concert'
      if sell_in < 11
        amount += 1
      end
      if sell_in < 6
        amount += 1
      end
    end
    if sell_in < 0
      if name == "Aged Brie"
       amount += 1
      end
    end
    amount
  end
  
  def amount_to_reduce_quality_by
    if sell_in > 0
      1
    else
      if name == "Backstage passes to a TAFKAL80ETC concert"
        quality
      else
        2
      end
    end
  end
end

class LegendaryItemUpdater < ItemUpdater
end
class AgedItemUpdater < ItemUpdater
end
class BackstageItemUpdater < ItemUpdater
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

