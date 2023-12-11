#!/usr/bin/env ruby

require 'numo/narray'

class Universe
  attr_accessor :space, :height, :width, :galaxies

  def initialize(input)
    @height = input.size
    @width = input[0].size
    @space = Numo::UInt8.zeros(@width, @height)
    @height.times do |y|
      @width.times do |x|
        @space[y, x] = 1 if input[y][x] == '#'
      end
    end
    @galaxies = nil
  end

  def expand!
    expand_y = []
    expand_x = []

    @height.times do |y|
      empty = true
      @width.times do |x|
        if @space[y, x] == 1
          empty = false
          break
        end
      end
      expand_y << y if empty
    end

    @width.times do |x|
      empty = true
      @height.times do |y|
        if @space[y, x] == 1
          empty = false
          break
        end
      end
      expand_x << x if empty
    end

    expanded_height = @height + expand_y.size
    expanded_space = Numo::UInt8.zeros(expanded_height, @width)
    height_expansions = 0
    @height.times do |y|
      @width.times do |x|
        expanded_space[height_expansions + y, x] =
          @space[y, x]
      end
      if expand_y.include? y
        @width.times do |x|
          expanded_space[height_expansions + y + 1, x] = 0
        end
        height_expansions += 1
      end
    end
    @space = expanded_space
    @height = expanded_height

    expanded_width = @width + expand_x.size
    expanded_space = Numo::UInt8.zeros(expanded_height, expanded_width)
    width_expansions = 0
    @width.times do |x|
      @height.times do |y|
        expanded_space[y, width_expansions + x] =
          @space[y, x]
      end
      if expand_x.include? x
        @height.times do |y|
          expanded_space[y, width_expansions + x + 1] = 0
        end
        width_expansions += 1
      end
    end
    @space = expanded_space
    @width = expanded_width
  end

  def find_galaxies!
    @galaxies = []
    @height.times do |y|
      @width.times do |x|
        @galaxies << [y, x] if space[y, x] == 1
      end
    end
  end

  def distances
    distance = 0
    @galaxies.permutation(2).map do |pair|
      distance += (pair[0][0] - pair[1][0]).abs +
                  (pair[0][1] - pair[1][1]).abs
    end
    distance / 2
  end

  def inspect
    to_s
  end

  def to_s
    s = "<#{self.class}:\n"
    @height.times do |y|
      @width.times do |x|
        s += @space[y, x].to_s
      end
      s += "\n"
    end
    s += ">"
  end
end

input = File.read('11.input').lines.map(&:strip).map(&:chars)

u = Universe.new input
u.expand!
u.find_galaxies!
print u.distances, "\n"
