#!/usr/bin/env crystal run --release

enum Operation
  Add
  Multiply
  Concat
end

PART1_OPERATIONS = [Operation::Add, Operation::Multiply]
PART2_OPERATIONS = [Operation::Add, Operation::Multiply, Operation::Concat]
INPUT_FILE       = "day7.input"
BASE_10          = 10_i64

class Equation
  def initialize(@target : Int64, @numbers : Array(Int64))
    @stack = Deque(Tuple(Int32, Int64)).new(@numbers.size * 3)
  end

  private def digit_length(n : Int64) : Int32
    return 1 if n == 0
    (Math.log10(n.abs).floor + 1).to_i
  end

  @[AlwaysInline]
  private def apply_operation(op : Operation, x : Int64, y : Int64) : Int64
    case op
    when Operation::Add
      x + y
    when Operation::Multiply
      x * y
    when Operation::Concat
      x * (BASE_10 ** digit_length(y)) + y
    else
      raise ArgumentError.new("Unknown operation: #{op}")
    end
  end

  @[AlwaysInline]
  private def within_bounds?(value : Int64) : Bool
    value.abs <= @target.abs
  end

  def solve(operations : Array(Operation)) : Int64
    return 0_i64 if @numbers.empty?
    return @numbers[0] if @numbers.size == 1

    if @numbers.size == 2
      operations.each do |op|
        result = apply_operation(op, @numbers[0], @numbers[1])
        return @target if result == @target
      end
      return 0_i64
    end

    first_val = @numbers[0]
    return 0_i64 if !within_bounds?(first_val)

    @stack.clear
    @stack.push({0, first_val})

    while !@stack.empty?
      pos, current_value = @stack.pop

      if pos >= @numbers.size - 1
        return @target if current_value == @target
        next
      end

      next_num = @numbers[pos + 1]
      operations.each do |op|
        if op == Operation::Concat
          next if !within_bounds?(current_value) || !within_bounds?(next_num)
        end

        result = apply_operation(op, current_value, next_num)
        next if !within_bounds?(result)
        @stack.push({pos + 1, result})
      end
    end

    0_i64
  end
end

def parse_input(filename : String) : Array(Equation)
  begin
    lines = File.read_lines(filename)
    equations = Array(Equation).new(initial_capacity: lines.size)

    lines.each do |line|
      left, right = line.split(": ")
      equations << Equation.new(
        left.to_i64,
        right.split(" ").map(&.to_i64)
      )
    end

    equations
  rescue e : Exception
    STDERR.puts "Error reading input file: #{e.message}"
    exit(1)
  end
end

def solve_part1(equations : Array(Equation)) : Int64
  equations.reduce(0_i64) { |acc, eq| acc + eq.solve(PART1_OPERATIONS) }
end

def solve_part2(equations : Array(Equation)) : Int64
  equations.reduce(0_i64) { |acc, eq| acc + eq.solve(PART2_OPERATIONS) }
end

equations = parse_input(INPUT_FILE)

# Run original solution
time = Time.local
puts "Part 1: #{solve_part1(equations)}"
puts "Time elapsed: #{(Time.local - time).total_milliseconds.round(2)}ms"
time = Time.local
puts "Part 2: #{solve_part2(equations)}"
puts "Time elapsed: #{(Time.local - time).total_milliseconds.round(2)}ms"
