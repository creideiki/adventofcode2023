#!/usr/bin/env ruby

require 'numo/narray'

class Pattern
  attr_accessor :map

  def initialize(input)
    @height = input.size
    @width = input[0].size
    @map = Numo::UInt8.zeros(@height, @width)
    @height.times do |y|
      @width.times do |x|
        @map[y, x] = 1 if input[y][x] == '#'
      end
    end
  end

  def horizontal_reflection_defects(candidate_row)
    return -1 if candidate_row <= 0 or candidate_row >= @height

    defects = 0
    1.upto([candidate_row, @height - candidate_row].min) do |check_offset|
      @width.times do |x|
        if @map[candidate_row + check_offset - 1, x] !=
           @map[candidate_row - check_offset, x]
          defects += 1
        end
      end
    end
    defects
  end

  def vertical_reflection_defects(candidate_col)
    return -1 if candidate_col <= 0 or candidate_col >= @width

    defects = 0
    1.upto([candidate_col, @width - candidate_col].min) do |check_offset|
      @height.times do |y|
        if @map[y, candidate_col + check_offset - 1] !=
           @map[y, candidate_col - check_offset]
          defects += 1
        end
      end
    end
    defects
  end

  def score_horizontal_reflection
    1.upto(@height - 1) do |candidate_row|
      if horizontal_reflection_defects(candidate_row) == 1
        return 100 * candidate_row
      end
    end
    0
  end

  def score_vertical_reflection
    1.upto(@width - 1) do |candidate_col|
      if vertical_reflection_defects(candidate_col) == 1
        return candidate_col
      end
    end
    0
  end

  def score
    score_horizontal_reflection + score_vertical_reflection
  end

  def inspect
    to_s
  end

  def to_s
    s = "<#{self.class}:\n"
    @height.times do |y|
      @width.times do |x|
        s += @map[y, x].to_s
      end
      s += "\n"
    end
    s += ">"
  end
end

input = File.read('13.input').lines.map(&:strip).map(&:chars)

patterns = []
lines = []
input.each do |line|
  if line.empty?
    patterns << Pattern.new(lines)
    lines = []
  else
    lines << line
  end
end
patterns << Pattern.new(lines)

print patterns.sum(&:score), "\n"
