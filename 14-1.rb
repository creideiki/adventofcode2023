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

  def tilt_north!
    @height.times do |y|
      @width.times do |x|
        if @map[y, x] == 1
          move_north!(y, x)
        end
      end
    end
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
dish.tilt_north!
print dish.load, "\n"
