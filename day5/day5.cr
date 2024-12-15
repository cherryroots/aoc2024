#!/usr/bin/env crystal run --release

time = Time.local

# Helper functions
def valid?(pages : Array(Int32), page_order : Hash(Int32, Array(Int32))) : Bool
  seen = {} of Int32 => Bool
  pages.each do |page|
    if deps = page_order[page]?
      return false if deps.any? { |dep| seen[dep]? }
    end
    seen[page] = true
  end
  true
end

def order_pages(pages : Array(Int32), page_order : Hash(Int32, Array(Int32))) : Array(Int32)
  result = [] of Int32
  remaining_pages = Set.new(pages)

  while !remaining_pages.empty?
    next_page = remaining_pages.find do |page|
      remaining_pages.all? do |other|
        other == page || !page_order[other]?.try(&.includes?(page))
      end
    end

    break unless next_page
    result << next_page
    remaining_pages.delete(next_page)
  end

  remaining_pages.empty? ? result : raise "Could not order pages"
end

class Array(T)
  def middle : T
    raise "Cannot get middle of empty array" if empty?
    size.odd? ? self[size // 2] : (self[size // 2 - 1] + self[size // 2]) // 2
  end
end

# Data structures
page_order = {} of Int32 => Array(Int32)
updates = [] of Array(Int32)

# Parse input
File.each_line("day5.input") do |line|
  next if line.empty?
  numbers = line.split(/[^\d]+/).reject(&.empty?).map &.to_i
  case numbers.size
  when 2
    (page_order[numbers[0]] ||= Array(Int32).new(4)) << numbers[1]
  when .> 2
    updates << numbers
  end
end

# Process updates and calculate results
sums = updates.reduce({0, 0}) do |acc, update|
  valid = valid?(update, page_order)
  middle = valid ? update.middle : order_pages(update, page_order).middle
  {
    acc[0] + (valid ? middle : 0),
    acc[1] + (valid ? 0 : middle),
  }
end

# Output results
puts "Time elapsed: #{(Time.local - time).total_milliseconds}ms"
puts "Part 1: #{sums[0]}"
puts "Part 2: #{sums[1]}"
