#!/usr/bin/env crystal

time = Time.local

class Guard
  DIRECTION_TURNS = {
    "north" => "east",
    "east"  => "south",
    "south" => "west",
    "west"  => "north",
  }

  DIRECTION_DELTAS = {
    "north" => {0, -1},
    "east"  => {1, 0},
    "south" => {0, 1},
    "west"  => {-1, 0},
  }

  getter direction : String

  def initialize(@direction : String)
  end

  def turn_right
    @direction = DIRECTION_TURNS[@direction]
  end

  def delta
    DIRECTION_DELTAS[@direction]
  end
end

class Obstacle
end

class Cell
  getter x : Int32
  getter y : Int32
  property contains : Guard? | Obstacle?
  getter visited : Bool

  def initialize(@x : Int32, @y : Int32, @contains : Guard? | Obstacle?, @visited : Bool = false)
  end

  def visit
    @visited = true
  end

  def visited?
    @visited
  end

  def guard?
    @contains.is_a?(Guard)
  end

  def obstacle?
    @contains.is_a?(Obstacle)
  end
end

class Map
  getter cells : Array(Array(Cell))
  @guard_pos : {Int32, Int32}?
  @visited_count : Int32 = 0

  def initialize(@cells : Array(Array(Cell)))
    @guard_pos = find_initial_guard
    @visited_count = 1 # Initial guard position is visited
  end

  private def find_initial_guard : {Int32, Int32}
    @cells.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        if cell.guard?
          cell.visit
          return {x, y}
        end
      end
    end
    raise "No guard found in initial position"
  end

  def get_cell(x : Int32, y : Int32) : Cell?
    return nil if y < 0 || y >= @cells.size
    return nil if x < 0 || x >= @cells[0].size
    @cells[y][x]
  end

  def run
    while move_guard
    end
  end

  def print
    @cells.each do |row|
      row.each do |cell|
        if cell.guard?
          print "G"
        elsif cell.obstacle?
          print "#"
        elsif cell.visited?
          print "X"
        else
          print "·"
        end
      end
      puts
    end
  end

  def move_guard : Bool
    return false unless guard_pos = @guard_pos
    x, y = guard_pos
    current_cell = @cells[y][x]
    guard = current_cell.contains.as(Guard)

    # Calculate next position based on direction
    dx, dy = guard.delta
    next_x = x + dx
    next_y = y + dy

    next_cell = get_cell(next_x, next_y)

    # Check if we hit a wall or obstacle
    if next_cell.nil? || next_cell.obstacle?
      guard.turn_right
      return true
    end

    # Move guard to new position
    next_cell.contains = guard
    current_cell.contains = nil
    unless next_cell.visited?
      next_cell.visit
      @visited_count += 1
    end

    @guard_pos = {next_x, next_y}

    # Check if we've reached the edge
    next_x == 0 || next_x == @cells[0].size - 1 || next_y == 0 || next_y == @cells.size - 1 ? false : true
  end

  def count_visited
    @visited_count
  end
end

lines = File.read_lines("day6.input")
map = Map.new(lines.map_with_index do |line, y|
  line.chars.map_with_index do |char, x|
    case char
    when '^'
      Cell.new(x, y, Guard.new("north"))
    when '#'
      Cell.new(x, y, Obstacle.new)
    else
      Cell.new(x, y, nil)
    end
  end
end)

map.run

puts "Time elapsed: #{(Time.local - time).total_milliseconds}ms"
puts "Part 1: #{map.count_visited}"
