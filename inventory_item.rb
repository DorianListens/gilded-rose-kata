class InventoryManager
  def self.for(item)
    name = item.name
   case
   when /Sulfuras/.match(name)
     return LegendaryInventoryManager.new(item)
   when /Backstage/.match(name)
     return BackstageInventoryManager.new(item)
   when /Aged/.match(name)
     return AgedInventoryManager.new(item)
   when /Conjured/.match(name)
     return ConjuredInventoryManager.new(item)
   else
     return InventoryManager.new(item)
   end 
  end

  def initialize(item)
    @item = item
  end

  def update
    @item.sell_in -= 1
    change_item_quality(amount)
  end

  def change_item_quality(amount)
    @item.quality += amount
    if @item.quality <= 0
      @item.quality = 0
    elsif @item.quality >= 50
      @item.quality = 50
    end
  end

  def amount
    if @item.sell_in > 0
      -1
    else
      -2
    end
  end
end

class LegendaryInventoryManager < InventoryManager
  def update
  end
end

class AgedInventoryManager < InventoryManager
  def amount
    if @item.sell_in < 0
      2
    else
      1
    end
  end
end

class BackstageInventoryManager < InventoryManager
  def amount
    if is_expired
      amount = - @item.quality
    else
      amount = 1
      if @item.sell_in < 10
        amount += 1
      end
      if @item.sell_in < 5
        amount += 1
      end
      amount
    end
  end

  def is_expired
    @item.sell_in < 0
  end
end

class ConjuredInventoryManager < InventoryManager
  def amount
    super * 2
  end
end
