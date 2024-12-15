#!/usr/bin/env crystal run --release

time = Time.local

safe_reports_part1 = 0
safe_reports_part2 = 0

LOWER_THRESHOLD = 1
UPPER_THRESHOLD = 3

def safe?(arr : Array(Int32)) : Bool
  is_ascending, is_descending, is_within_threshold = true, true, true
  arr.each_cons(2) do |pair|
    difference = (pair[0] - pair[1]).abs
    is_ascending &&= pair[0] <= pair[1]
    is_descending &&= pair[0] >= pair[1]
    is_within_threshold &&= LOWER_THRESHOLD <= difference <= UPPER_THRESHOLD
  end
  (is_ascending || is_descending) && is_within_threshold
end

File.each_line("day2.input") do |line|
  report = line.scan(/\d+/).map(&.to_s.to_i)

  safe_reports_part1 += 1 if safe?(report)

  report.each_index do |i|
    if safe?(report[0...i] + report[i + 1..-1])
      safe_reports_part2 += 1
      break
    end
  end
end

puts "Time elapsed: #{(Time.local - time).total_milliseconds}ms"
puts "Part 1: #{safe_reports_part1}"
puts "Part 2: #{safe_reports_part2}"
