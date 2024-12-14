#!/usr/bin/env crystal

class Equation
  getter left : Int64
  getter right : Array(Int64)
  getter operators : Array(Proc(Int64, Int64, Int64))
  private property found = false

  def initialize(@left : Int64, @right : Array(Int64), @operators : Array(Proc(Int64, Int64, Int64)))
  end

  def solve : Int64
    evaluate(@right)
    @found ? return @left : 0.to_i64
  end

  private def evaluate(nums : Array(Int64)) : Int64?
    return nums[0] if nums.size == 1
    return nil if nums.empty?

    @operators.each do |op|
      new_nums = nums.dup
      result = op.call(new_nums[0], new_nums[1])
      new_nums.delete_at(1)
      new_nums[0] = result

      if new_nums.size == 1
        if new_nums[0] == @left
          @found = true
          return result
        end
        next
      end

      if sub_result = evaluate(new_nums)
        return sub_result if @found
      end
    end
    nil
  end
end

equations = [] of Equation

time = Time.local

part1_operators = [
  ->(x : Int64, y : Int64) { x + y },
  ->(x : Int64, y : Int64) { x * y },
]

part1_equations = [] of Equation

part2_operators = [
  ->(x : Int64, y : Int64) { x + y },
  ->(x : Int64, y : Int64) { x * y },
  ->(x : Int64, y : Int64) { (x.to_s + y.to_s).to_i64 },
]

part2_equations = [] of Equation

time = Time.local

File.each_line("day7.input") do |line|
  left, right = line.split(": ")
  left = left.to_i64
  right = right.split(" ").map(&.to_i64)
  part1_equations << Equation.new(left, right, part1_operators)
  part2_equations << Equation.new(left, right, part2_operators)
end

puts "Time elapsed parsing: #{(Time.local - time).total_milliseconds}ms"

part1_time = Time.local
part1_sum = part1_equations.map(&.solve).sum

puts "Part 1: #{part1_sum}"
puts "Time elapsed: #{(Time.local - part1_time).total_milliseconds}ms"

part2_time = Time.local
part2_sum = part2_equations.map(&.solve).sum

puts "Part 2: #{part2_sum}"
puts "Time elapsed: #{(Time.local - part2_time).total_milliseconds}ms"
