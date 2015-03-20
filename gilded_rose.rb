def update_quality(items)
  items.each do |item|
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
  if item.sell_in < 0
    if item.name != "Aged Brie"
      if item.name != 'Backstage passes to a TAFKAL80ETC concert'
        if item.quality > 0
          if item.name != 'Sulfuras, Hand of Ragnaros'
            item.quality -= 1
          end
        end
      else
        item.quality = item.quality - item.quality
      end
    else
      if item.quality < 50
        item.quality += 1
      end
    end
  end
end

def update_sell_in(item)
  if item.name != 'Sulfuras, Hand of Ragnaros'
    item.sell_in -= 1
  end
end

def should_reduce_item_quality(item)
  item.name != 'Aged Brie' && item.name != 'Backstage passes to a TAFKAL80ETC concert' && item.name != 'Sulfuras, Hand of Ragnaros'

end

def reduce_item_quality(item)
  if item.quality > 0
    item.quality -= 1
  end
end

def increase_item_quality(item)
  if item.quality < 50
    item.quality += 1
    if item.name == 'Backstage passes to a TAFKAL80ETC concert'
      if item.sell_in < 11
        if item.quality < 50
          item.quality += 1
        end
      end
      if item.sell_in < 6
        if item.quality < 50
          item.quality += 1
        end
      end
    end
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

