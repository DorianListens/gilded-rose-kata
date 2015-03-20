class ItemUpdater
  def self.new(item)
    @item = item
  end
end


def update_quality(items)
  items.each do |item|
    updater = ItemUpdater.new(item)
    update_sell_in(item)
    update_item_quality(item)
  end
end

def update_item_quality(item)
  if should_reduce_item_quality(item)
    reduce_item_quality(item)
  else
    increase_item_quality(item)
  end
end

def update_sell_in(item)
  if item.name != 'Sulfuras, Hand of Ragnaros'
    item.sell_in -= 1
  end
end

def should_reduce_item_quality(item)
  case
  when item.name == 'Aged Brie' || item.name == 'Sulfuras, Hand of Ragnaros'
    return false
  when item.name == 'Backstage passes to a TAFKAL80ETC concert'
    if item.sell_in > 0
      return false
    else
      return true
    end
  else
    return true
  end
end

def reduce_item_quality(item)
  if item.quality > 0
    item.quality -= amount_to_reduce_by(item)
  end
end

def amount_to_reduce_by(item)
  if item.sell_in > 0
    1
  else
    amount_to_reduce_by_after_sell_in(item)
  end
end

def amount_to_reduce_by_after_sell_in(item)
  if item.name == "Backstage passes to a TAFKAL80ETC concert"
    item.quality
  else
    2
  end
end

def increase_item_quality(item)
  if item.quality < 50
    item.quality += amount_to_increase_quality_by(item)
  end
end

def amount_to_increase_quality_by(item)
  amount = 1
  if item.name == 'Backstage passes to a TAFKAL80ETC concert'
    if item.sell_in < 11
      amount += 1
    end
    if item.sell_in < 6
      amount += 1
    end
  end
  if item.sell_in < 0
    if item.name = "Aged Brie"
     amount += 1
    end
  end
  amount
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

