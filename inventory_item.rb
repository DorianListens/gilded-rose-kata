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
    if @item.quality > 0
      @item.quality -= amount_to_reduce_quality_by
    end
  end

  def increase_item_quality
    new_quality = @item.quality += amount_to_increase_quality_by
    if new_quality > 50
      new_quality = 50
    end
    @item.quality = new_quality
  end

  def amount_to_increase_quality_by
    1
  end
  
  def amount_to_reduce_quality_by
    if @item.sell_in > 0
      1
    else
      2
    end
  end
end

class LegendaryInventoryManager < InventoryManager
  def update
  end
end

class AgedInventoryManager < InventoryManager
  def amount_to_increase_quality_by
    if @item.sell_in < 0
      2
    else
      1
    end
  end

  def should_reduce_item_quality
    false
  end
end

class BackstageInventoryManager < InventoryManager
  def amount_to_increase_quality_by
    amount = 1
    if @item.sell_in < 10
      amount += 1
    end
    if @item.sell_in < 5
      amount += 1
    end
    amount
  end

  def should_reduce_item_quality
    @item.sell_in < 0
  end

  def amount_to_reduce_quality_by
    @item.quality
  end
end

class ConjuredInventoryManager < InventoryManager
  def amount_to_reduce_quality_by
    super * 2
  end
end
