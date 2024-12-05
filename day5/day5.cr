#!/usr/bin/env crystal

time = Time.local

# Helper functions
def middle_number(arr : Array(Int32)) : Int32
  arr.size.odd? ? arr[arr.size // 2] : (arr[arr.size // 2 - 1] + arr[arr.size // 2]) // 2
end

def valid?(arr : Array(Int32), page_order : Hash(Int32, Array(Int32))) : Bool
  arr.each_with_index.none? do |page, j|
    page_values = page_order[page]?
    page_values && arr[0..j].to_set.intersects?(page_values.to_set)
  end
end

def order_page(arr : Array(Int32), page_order : Hash(Int32, Array(Int32))) : Array(Int32)
  result = [] of Int32
  remaining = arr.dup

  while !remaining.empty?
    next_page = remaining.find do |page|
      remaining.none? { |other| page_order[other]?.try(&.includes?(page)) || false }
    end

    break unless next_page # if there is no next page, we have a loop

    result << next_page
    remaining.delete(next_page)
  end

  remaining.empty? ? result : arr
end

# Data structures
page_order : Hash(Int32, Array(Int32)) = {} of Int32 => Array(Int32)
updates : Array(Array(Int32)) = [] of Array(Int32)

# Parse input
File.each_line("day5.input") do |line|
  next unless numbers = line.scan(/\d+/).map(&.to_s.to_i)
  if numbers.size == 2
    page_order[numbers.first] ||= Array(Int32).new
    page_order[numbers.first] << numbers.last
  elsif numbers.size > 2
    updates << numbers
  end
end

# Process updates and calculate results
sums = updates.reduce({0, 0}) do |acc, update|
  {
    acc[0] + (valid?(update, page_order) ? middle_number(update) : 0),
    acc[1] + (valid?(update, page_order) ? 0 : middle_number(order_page(update, page_order))),
  }
end

# Output results
puts "Time elapsed: #{(Time.local - time).total_milliseconds}ms"
puts "Part 1: #{sums[0]}"
puts "Part 2: #{sums[1]}"
