#!/usr/bin/env ruby

require 'numo/narray'

class Universe
  attr_accessor :space, :height, :width, :galaxies, :expand_rows, :expand_cols

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
    @expand_rows = nil
    @expand_cols = nil
  end

  def expand!
    @expand_rows = []
    @expand_cols = []

    @height.times do |y|
      empty = true
      @width.times do |x|
        if @space[y, x] == 1
          empty = false
          break
        end
      end
      @expand_rows << y if empty
    end

    @width.times do |x|
      empty = true
      @height.times do |y|
        if @space[y, x] == 1
          empty = false
          break
        end
      end
      @expand_cols << x if empty
    end
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
      top = [pair[0][0], pair[1][0]].min
      bottom = [pair[0][0], pair[1][0]].max
      left = [pair[0][1], pair[1][1]].min
      right = [pair[0][1], pair[1][1]].max

      horizontal_distance = 0
      vertical_distance = 0

      top.upto(bottom - 1) do |y|
        vertical_distance += 1_000_000 - 1 if @expand_rows.include? y
        vertical_distance += 1
      end

      left.upto(right - 1) do |x|
        horizontal_distance += 1_000_000 - 1 if @expand_cols.include? x
        horizontal_distance += 1
      end

      distance += horizontal_distance + vertical_distance
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
