#!/usr/bin/env crystal

time = Time.local

struct Position
  getter x : Int32
  getter y : Int32

  def initialize(@x : Int32, @y : Int32)
  end
end

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
  getter position : Position
  property contains : Guard? | Obstacle?
  getter visited : Bool

  def initialize(@position : Position, @contains : Guard? | Obstacle?, @visited : Bool = false)
  end

  def visit
    @visited = true
  end

  def unvisit
    @visited = false
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
  @initial_guard_pos : Position
  @guard_pos : Position?
  @visited_count : Int32 = 0

  def initialize(@cells : Array(Array(Cell)))
    @initial_guard_pos = find_initial_guard
    @guard_pos = find_initial_guard
    @visited_count = 1 # Initial guard position is visited
  end

  private def find_initial_guard : Position
    @cells.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        if cell.guard?
          cell.visit
          return Position.new(x, y)
        end
      end
    end
    raise "No guard found in initial position"
  end

  def get_cell(position : Position) : Cell?
    return nil if position.y < 0 || position.y >= @cells.size
    return nil if position.x < 0 || position.x >= @cells[0].size
    @cells[position.y][position.x]
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
    current_cell = @cells[guard_pos.y][guard_pos.x]
    guard = current_cell.contains.as(Guard)

    dx, dy = guard.delta
    next_x = guard_pos.x + dx
    next_y = guard_pos.y + dy

    next_cell = get_cell(Position.new(next_x, next_y))

    if next_cell.nil? || next_cell.obstacle?
      guard.turn_right
      return true
    end

    next_cell.contains = guard
    current_cell.contains = nil
    unless next_cell.visited?
      next_cell.visit
      @visited_count += 1
    end

    @guard_pos = Position.new(next_x, next_y)

    next_x == 0 || next_x == @cells[0].size - 1 || next_y == 0 || next_y == @cells.size - 1 ? false : true
  end

  def reset_to_initial
    @cells.each do |row|
      row.each do |cell|
        cell.unvisit
        cell.contains = nil if cell.guard?
      end
    end

    @cells[@initial_guard_pos.y][@initial_guard_pos.x].contains = Guard.new("north")
    @cells[@initial_guard_pos.y][@initial_guard_pos.x].visit
    @guard_pos = @initial_guard_pos
    @visited_count = 1
  end

  def count_visited
    @visited_count
  end

  def run
    while move_guard
    end
  end
end

lines = File.read_lines("day6.input")
map = Map.new(lines.map_with_index do |line, y|
  line.chars.map_with_index do |char, x|
    case char
    when '^'
      Cell.new(Position.new(x, y), Guard.new("north"))
    when '#'
      Cell.new(Position.new(x, y), Obstacle.new)
    else
      Cell.new(Position.new(x, y), nil)
    end
  end
end)

map.run
puts "Part 1: #{map.count_visited}"
map.reset_to_initial

puts "Part 2: "
puts "Time elapsed: #{(Time.local - time).total_milliseconds}ms"
