#!/usr/bin/env crystal

time = Time.local

left_list = [] of Int32
right_list = [] of Int32

File.each_line("day1.input") do |line|
  if numbers = line.scan(/\d+/)
    left_list << numbers[0].to_s.to_i
    right_list << numbers[-1].to_s.to_i
  end
end

part1 = left_list.sort.zip(right_list.sort).sum { |l, r| (l - r).abs }

left_freq = left_list.tally
right_freq = right_list.tally

part2 = (left_list.to_set & right_list.to_set).sum do |n|
  n * (left_freq[n] * right_freq[n])
end

puts "Time elapsed: #{(Time.local - time).total_milliseconds}ms"
puts "Day 1: #{part1}"
puts "Day 2: #{part2}"
