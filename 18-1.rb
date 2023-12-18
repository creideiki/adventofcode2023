#!/usr/bin/env ruby

require 'numo/narray'

class Map
  attr_accessor :map, :pos

  def initialize(size)
    @height = size
    @width = size
    @map = Numo::UInt8.zeros(@height, @width)
    @pos = {y: 1, x: 1}
    @map[@pos[:y], @pos[:x]] = 1
  end

  def step!(dir, length)
    case dir
    when 'U'
      new_y = @pos[:y] - length
      add = 0
      if new_y < 1
        add = new_y.abs + 1
        ext = Numo::UInt8.zeros(add, @width)
        @map = ext.append(@map, axis: 0)
        new_y += add
        @height += add
      end
      (@pos[:y] + add).downto(new_y) { |y| map[y, @pos[:x]] = 1 }
      @pos[:y] = new_y
    when 'R'
      new_x = @pos[:x] + length
      if new_x > @width - 2
        add = new_x - @width + 2
        ext = Numo::UInt8.zeros(@height, add)
        @map = @map.append(ext, axis: 1)
        @width += add
      end
      @pos[:x].upto(new_x) { |x| map[@pos[:y], x] = 1 }
      @pos[:x] = new_x
    when 'D'
      new_y = @pos[:y] + length
      if new_y > @height - 2
        add = new_y - @height + 2
        ext = Numo::UInt8.zeros(add, @width)
        @map = @map.append(ext, axis: 0)
        @height += add
      end
      @pos[:y].upto(new_y) { |y| map[y, @pos[:x]] = 1 }
      @pos[:y] = new_y
    when 'L'
      new_x = @pos[:x] - length
      add = 0
      if new_x < 1
        add = new_x.abs + 1
        ext = Numo::UInt8.zeros(@height, add)
        @map = ext.append(@map, axis: 1)
        new_x += add
        @width += add
      end
      (@pos[:x] + add).downto(new_x) { |x| map[@pos[:y], x] = 1 }
      @pos[:x] = new_x
    end
  end

  def dig!(insns)
    instruction_format = /^(?<dir>[URLD]) (?<length>[[:digit:]]+) \(#(?<colour>[[:xdigit:]]{6})\)$/
    insns.each do |insn|
      m = insn.match instruction_format
      dir = m['dir']
      length = m['length'].to_i
      old_pos = @pos
      step!(dir, length)
    end
  end

  def flood_fill_exterior!
    queue = [{y: 0, x: 0}]
    until queue.empty?
      cell = queue.shift
      next if cell[:y] < 0 or cell[:y] > @height - 1 or
        cell[:x] < 0 or cell[:x] > @width - 1
      next unless @map[cell[:y], cell[:x]] == 0

      @map[cell[:y], cell[:x]] = 2
      queue << {y: cell[:y] - 1, x: cell[:x]}
      queue << {y: cell[:y] + 1, x: cell[:x]}
      queue << {y: cell[:y], x: cell[:x] - 1}
      queue << {y: cell[:y], x: cell[:x] + 1}
    end
  end

  def count_interior
    count = 0
    @height.times do |y|
      @width.times do |x|
        count += 1 if @map[y, x] != 2
      end
    end
    count
  end

  def to_s
    s = "<#{self.class}:\n"
    @height.times do |y|
      @width.times do |x|
        s += if @pos[:y] == y and @pos[:x] == x
               '*'
             else
               case @map[y, x]
               when 0
                 '.'
               when 1
                 '#'
               when 2
                 'O'
               end
             end
      end
      s += "\n"
    end
    s += ">"
  end
end

input = File.read('18.input').lines.map(&:strip)

map = Map.new(input.size)
map.dig! input
map.flood_fill_exterior!
print map.count_interior, "\n"
