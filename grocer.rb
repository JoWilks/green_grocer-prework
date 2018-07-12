def consolidate_cart(cart)
# consolidate cart so multiple items are measured by a count, instead of multiple instances.
hash= Hash.new(0)
  cart.each {|full_item| full_item.each {|item_name, price_sale|
        if hash.empty? || !hash.include?(item_name)
          hash[item_name] = price_sale
          hash[item_name][:count] = 1
        elsif hash.include?(item_name)
          hash[item_name][:count] += 1
        end } }
hash
end

def apply_coupons(cart, coupons)
  temp_hash = {}
  #creates base item W/COUPON applied in temp_hash
  coupons.each {|coupon| 
    item_name = coupon[:item]
      if cart.include?(item_name) && cart[item_name][:count] >= coupon[:num]
        if cart.include?("#{item_name} W/COUPON")
          cart["#{item_name} W/COUPON"][:count] += 1 
        else  
          cart["#{item_name} W/COUPON"] = {:price => coupon[:cost], :clearance => cart[item_name][:clearance], :count => 1 }
        end
        cart[item_name][:count] -= coupon[:num]
      end
      }
  cart
end

def apply_clearance(cart)

  cart.each {|item_name, details| 
    details.each { |key, value| 
      if key == :clearance && value == true
        cart[item_name][:price] *= 0.8
        cart[item_name][:price] = (cart[item_name][:price]).round(2) 
      end
    }
  }  
cart
end

def checkout(cart, coupons)

  #consolidate cart
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)

sum_array = []

 cart.each {|item_name, details| #puts "LVL 1: #{item_name} & #{details}"
    details.each { |detail, value| #puts "LVL 2: #{detail} & #{value}"
      if detail == :price
        product = value * cart[item_name][:count]
        sum_array << product
      end
 }}

total = sum_array.inject(0){|sum, x| sum + x} 
  if total > 100
      total *= 0.9
  end
total  
end
