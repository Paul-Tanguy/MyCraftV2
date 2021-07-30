
arr = ["vibranium", "allthemodium", "emerald", "platinium", "steel", "silver", "stone", "wood"]
puts arr.zip(arr[1..-1]).map{|mat, jet|"
jetpacks:#{jet || "leather"}_jetpack 1
jetpacks:#{mat}_capacitor 1
jetpacks:#{mat}_thruster 2
forge:#{mat} 4
"}
# .map{|mat|
#     "jetpacks:#{mat}_jetpack"
# }

# puts "jetpacks:"