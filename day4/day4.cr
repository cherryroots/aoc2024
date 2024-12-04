#!/usr/bin/env crystal

time = Time.local

enum Direction
  North
  North_east
  East
  South_east
  South
  South_west
  West
  North_west
end

struct Point
  getter x : Int32
  getter y : Int32

  def initialize(@x : Int32, @y : Int32)
  end
end

array_2d = [] of Array(String)

File.each_line("day4.input") do |line|
  array_2d << line.chars.map(&.to_s)
end

total_xmas = 0
total_x_mas = 0

def get_direction(array : Array(Array(String)), start : Point, direction : Direction) : Tuple(String, Point)
  y = case direction
      when .north?, .north_east?, .north_west?
        start.y - 1
      when .south?, .south_east?, .south_west?
        start.y + 1
      else
        start.y
      end

  x = case direction
      when .north_east?, .east?, .south_east?
        start.x + 1
      when .north_west?, .west?, .south_west?
        start.x - 1
      else
        start.x
      end

  return {".", Point.new(x, y)} if y < 0 || y >= array.size || x < 0 || x >= array[0].size

  {array[y][x], Point.new(x, y)}
end

# Part 1
array_2d.each_with_index do |arr, y|
  arr.each_with_index do |char, x|
    if char == "X"
      Direction.values.each do |direction|
        string, point = get_direction(array_2d, Point.new(x, y), direction)
        unless string == "M"
          next
        end
        string, point = get_direction(array_2d, point, direction)
        unless string == "A"
          next
        end
        string, point = get_direction(array_2d, point, direction)
        unless string == "S"
          next
        end
        total_xmas += 1
      end
    end
  end
end

# Part 2
array_2d.each_with_index do |arr, y|
  arr.each_with_index do |char, x|
    if char == "A"
      center = Point.new(x, y)
      top_left = get_direction(array_2d, center, Direction::North_west)
      top_right = get_direction(array_2d, center, Direction::North_east)
      bottom_left = get_direction(array_2d, center, Direction::South_west)
      bottom_right = get_direction(array_2d, center, Direction::South_east)
      mas_count = 0
      if top_left[0] == "M" && bottom_right[0] == "S"
        mas_count += 1
      end
      if top_right[0] == "M" && bottom_left[0] == "S"
        mas_count += 1
      end
      if bottom_right[0] == "M" && top_left[0] == "S"
        mas_count += 1
      end
      if bottom_left[0] == "M" && top_right[0] == "S"
        mas_count += 1
      end
      total_x_mas += 1 if mas_count >= 2
    end
  end
end

puts "Time elapsed: #{(Time.local - time).total_milliseconds}ms"
puts "Total XMAS: #{total_xmas}"
puts "Total X-MAS: #{total_x_mas}"
