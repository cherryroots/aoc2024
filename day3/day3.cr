#!/usr/bin/env crystal

time = Time.local

total_sum_part1 = 0
total_sum_part2 = 0

enum Operation
  Enabled
  Disabled
  Mul
end

struct Instruction
  getter operation : Operation
  getter num1 : Int32
  getter num2 : Int32

  def initialize(@operation : Operation, @num1 : Int32 = 0, @num2 : Int32 = 0)
  end
end

instructions_array = [] of Instruction

File.each_line("day3.input") do |line|
  instructions = line.scan(/(mul\(\d+,\d+\))|(do\(\))|(don't\(\))/).map(&.to_s)

  instructions.each do |inst|
    case inst
    when "do()"
      instructions_array << Instruction.new(Operation::Enabled)
    when "don't()"
      instructions_array << Instruction.new(Operation::Disabled)
    else
      numbers = inst.scan(/\d+/).map(&.to_s.to_i)
      instructions_array << Instruction.new(Operation::Mul, numbers[0], numbers[1])
    end
  end
end

enabled = true

instructions_array.each do |inst|
  case inst.operation
  when .mul?
    total_sum_part1 += inst.num1 * inst.num2
    if enabled
      total_sum_part2 += inst.num1 * inst.num2
    end
  when .enabled?
    enabled = true
  when .disabled?
    enabled = false
  end
end

puts "Time elapsed: #{(Time.local - time).total_milliseconds}ms"
puts "Part 1: #{total_sum_part1}"
puts "Part 2: #{total_sum_part2}"
