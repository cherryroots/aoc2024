#!/usr/bin/env crystal

time = Time.local

safe_reports_part1, safe_reports_part2 = 0, 0

def safe?(arr : Array(Int32)) : Bool
  ascending, descending, min_max_difference = true, true, true
  arr.each_cons(2) do |pair|
    ascending &&= pair[0] <= pair[1]
    descending &&= pair[0] >= pair[1]
    min_max_difference &&= 1 <= (pair[0] - pair[1]).abs <= 3
  end
  (ascending || descending) && min_max_difference
end

File.each_line("../day2.input") do |line|
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
