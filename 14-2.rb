#!/usr/bin/env ruby

require 'numo/narray'

class Dish
  attr_accessor :map

  def initialize(input)
    @height = input.size
    @width = input[0].size
    @map = Numo::UInt8.zeros(@height, @width)
    @height.times do |y|
      @width.times do |x|
        @map[y, x] = 1 if input[y][x] == 'O'
        @map[y, x] = 2 if input[y][x] == '#'
      end
    end
  end

  def load
    load = 0
    @height.times do |y|
      @width.times do |x|
        if @map[y, x] == 1
          load += @height - y
        end
      end
    end
    load
  end

  def move_north!(start_y, x)
    end_y = start_y
    (start_y - 1).downto(0) do |check_y|
      break unless map[check_y, x].zero?

      end_y = check_y
    end
    map[start_y, x] = 0
    map[end_y, x] = 1
    end_y
  end

  def move_south!(start_y, x)
    end_y = start_y
    (start_y + 1).upto(@height - 1) do |check_y|
      break unless map[check_y, x].zero?

      end_y = check_y
    end
    map[start_y, x] = 0
    map[end_y, x] = 1
    end_y
  end

  def move_west!(y, start_x)
    end_x = start_x
    (start_x - 1).downto(0) do |check_x|
      break unless map[y, check_x].zero?

      end_x = check_x
    end
    map[y, start_x] = 0
    map[y, end_x] = 1
    end_x
  end

  def move_east!(y, start_x)
    end_x = start_x
    (start_x + 1).upto(@width - 1) do |check_x|
      break unless map[y, check_x].zero?

      end_x = check_x
    end
    map[y, start_x] = 0
    map[y, end_x] = 1
    end_x
  end

  def tilt_north!
    @height.times do |y|
      @width.times do |x|
        if @map[y, x] == 1
          move_north!(y, x)
        end
      end
    end
  end

  def tilt_south!
    (@height - 1).downto(0) do |y|
      @width.times do |x|
        if @map[y, x] == 1
          move_south!(y, x)
        end
      end
    end
  end

  def tilt_west!
    @height.times do |y|
      @width.times do |x|
        if @map[y, x] == 1
          move_west!(y, x)
        end
      end
    end
  end

  def tilt_east!
    @height.times do |y|
      (@width - 1).downto(0) do |x|
        if @map[y, x] == 1
          move_east!(y, x)
        end
      end
    end
  end

  def cycle!
    tilt_north!
    tilt_west!
    tilt_south!
    tilt_east!
  end

  def spin!
    seen = []
    num_cycles = 0
    cycle_length = 0
    loop do
      seen << @map.copy
      cycle!
      num_cycles += 1
      if seen.index @map
        cycle_length = num_cycles - seen.index(@map)
        break
      end
    end

    _skip_cycles, remainder = (1_000_000_000 - num_cycles).divmod(cycle_length)
    remainder.times { |_| cycle! }
  end

  def inspect
    to_s
  end

  def to_s
    s = "<#{self.class}:\n"
    @height.times do |y|
      @width.times do |x|
        s += case @map[y, x]
             when 0
               '.'
             when 1
               'O'
             when 2
               '#'
             end
      end
      s += "\n"
    end
    s += ">"
  end
end

input = File.read('14.input').lines.map(&:strip).map(&:chars)

dish = Dish.new(input)
dish.spin!
print dish.load, "\n"
