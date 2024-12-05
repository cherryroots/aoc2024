#!/usr/bin/env crystal

time = Time.local

page_order : Hash(Int32, Array(Int32)) = {} of Int32 => Array(Int32)
updates : Array(Array(Int32)) = [] of Array(Int32)

File.each_line("day5.input") do |line|
  next unless numbers = line.scan(/\d+/).map(&.to_s.to_i)
  if numbers.size == 2
    page_order[numbers.first] ||= Array(Int32).new
    page_order[numbers.first] << numbers.last
  elsif numbers.size > 2
    updates << numbers
  end
end

def middle_number(arr : Array(Int32)) : Int32
  arr.size.odd? ? arr[arr.size // 2] : (arr[arr.size // 2 - 1] + arr[arr.size // 2]) // 2
end

sum = updates.each.sum do |update|
  invalid = update.each_with_index.sum do |page, j|
    next 0 unless page_order.has_key?(page)
    update[0..j].to_set.intersects?(page_order[page].to_set) ? 1 : 0
  end
  invalid == 0 ? middle_number(update) : 0
end

puts "Time elapsed: #{(Time.local - time).total_milliseconds}ms"
puts "Valid: #{sum}"
