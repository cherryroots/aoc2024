#!/usr/bin/env crystal run --release

time = Time.local

DIRECTIONS = {
  "north"      => {dx: 0, dy: -1},
  "north_east" => {dx: 1, dy: -1},
  "east"       => {dx: 1, dy: 0},
  "south_east" => {dx: 1, dy: 1},
  "south"      => {dx: 0, dy: 1},
  "south_west" => {dx: -1, dy: 1},
  "west"       => {dx: -1, dy: 0},
  "north_west" => {dx: -1, dy: -1},
}

struct Point
  getter x : Int32
  getter y : Int32

  def initialize(@x : Int32, @y : Int32)
  end
end

def get_direction(array : Array(Array(String)), start : Point, direction : String) : Tuple(String, Point)
  delta = DIRECTIONS[direction]
  x = start.x + delta[:dx]
  y = start.y + delta[:dy]

  return {".", Point.new(x, y)} if y < 0 || y >= array.size || x < 0 || x >= array[0].size

  {array[y][x], Point.new(x, y)}
end

word_search = File.read_lines("day4.input").map(&.chars.map(&.to_s))

# Part 1
total_xmas = word_search.each_with_index.sum do |arr, y|
  arr.each_with_index.sum do |char, x|
    next 0 unless char == "X"
    DIRECTIONS.count do |direction, _|
      m_char, m_point = get_direction(word_search, Point.new(x, y), direction)
      m_char == "M" || next false
      a_char, a_point = get_direction(word_search, m_point, direction)
      a_char == "A" || next false
      s_char, _ = get_direction(word_search, a_point, direction)
      s_char == "S" || next false
      next true
    end
  end
end

# Part 2
total_x_mas = word_search.each_with_index.sum do |arr, y|
  arr.each_with_index.sum do |char, x|
    next 0 unless char == "A"

    center = Point.new(x, y)
    top_left, _ = get_direction(word_search, center, "north_west")
    top_right, _ = get_direction(word_search, center, "north_east")
    bottom_left, _ = get_direction(word_search, center, "south_west")
    bottom_right, _ = get_direction(word_search, center, "south_east")
    mas_count = {
      top_left == "M" && bottom_right == "S",
      top_right == "M" && bottom_left == "S",
      bottom_right == "M" && top_left == "S",
      bottom_left == "M" && top_right == "S",
    }.count(true)

    next mas_count >= 2 ? 1 : 0
  end
end

puts "Time elapsed: #{(Time.local - time).total_milliseconds}ms"
puts "Part 1: #{total_xmas}"
puts "Part 2: #{total_x_mas}"
