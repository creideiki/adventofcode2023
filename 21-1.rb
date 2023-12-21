#!/usr/bin/env ruby

require 'numo/narray'

class Garden
  attr_accessor :map, :height, :width, :start

  def initialize(input)
    @height = input.size
    @width = input[0].size
    @map = Numo::UInt8.zeros(@width, @height)
    @start = [-1, -1]
    @height.times do |y|
      @width.times do |x|
        @map[y, x] = 1 if input[y][x] == '#'
        @start = [y, x] if input[y][x] == 'S'
      end
    end
  end

  def available?(y, x)
    y >= 0 and y < @height and
      x >= 0 and x < @width and
      @map[y, x] == 0
  end

  def walk(steps)
    previous_locations = [@start]
    steps.times do |n|
      new_locations = []
      previous_locations.each do |p|
        new_locations << [p[0] + 1, p[1]] if available?(p[0] + 1, p[1])
        new_locations << [p[0] - 1, p[1]] if available?(p[0] - 1, p[1])
        new_locations << [p[0], p[1] + 1] if available?(p[0], p[1] + 1)
        new_locations << [p[0], p[1] - 1] if available?(p[0], p[1] - 1)
      end
      previous_locations = new_locations.uniq
    end
    previous_locations.size
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
               '#'
             end
      end
      s += "\n"
    end
    s += ">"
  end
end

input = File.read('21.input').lines.map(&:strip).map(&:chars)

garden = Garden.new(input)
print garden.walk(64), "\n"
