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
puts coupons
puts cart
temp_hash = {}
cart_temp = cart

#creates base item W/COUPON applied in temp_hash
coupons.each {|x| x.each {|c_key, c_value| 
#  if c_key == :item
    cart_temp.each {|item_name, details| details.each { |detail, value| 
	      cpn_name = "#{item_name} W/COUPON" 
	      if item_name == c_value && temp_hash.empty?
	        temp_hash[cpn_name] = {}
	        temp_hash[cpn_name][:price] = ""
	        temp_hash[cpn_name][:clearance] = cart[item_name][:clearance]
	        temp_hash[cpn_name][:count] = 0
	      end
	      if c_key == :cost && !temp_hash.empty?
	        #puts "a!!"
	        temp_hash[cpn_name][:price] = c_value
	      end
	      if c_key == :num && detail == :count && !temp_hash.empty?
	        #puts "#{}"
	        temp_hash[cpn_name][:count] += 1
	        cart[item_name][:count] = value - c_value
        end
    }
    }
}
}

temp_hash.each {|key, value| cart[key] = value }
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
