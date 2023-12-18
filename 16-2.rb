#!/usr/bin/env ruby

class Contraption
  attr_accessor :map, :beams, :visited

  def initialize(input)
    @height = input.size
    @width = input[0].size

    @map = input
    @beams = []

    @visited = Array.new @height
    @visited = @visited.map { |_| Array.new @width }

    @height.times do |y|
      @width.times do |x|
        @visited[y][x] = []
      end
    end
  end

  def add_beam(y, x, dir)
    @beams << {y: y, x: x, dir: dir}
  end

  def energize!
    until beams.empty?
      @beams += step(@beams.shift)
    end
  end

  def step(beam)
    return [] if beam[:y] < 0 or beam[:y] >= @height or
      beam[:x] < 0 or beam[:x] >= @width
    return [] if @visited[beam[:y]][beam[:x]].include? beam[:dir]

    @visited[beam[:y]][beam[:x]] << beam[:dir]
    case @map[beam[:y]][beam[:x]]
    when '.'
      new_beam = {dir: beam[:dir]}
      case beam[:dir]
      when :north
        new_beam[:y] = beam[:y] - 1
        new_beam[:x] = beam[:x]
      when :east
        new_beam[:y] = beam[:y]
        new_beam[:x] = beam[:x] + 1
      when :south
        new_beam[:y] = beam[:y] + 1
        new_beam[:x] = beam[:x]
      when :west
        new_beam[:y] = beam[:y]
        new_beam[:x] = beam[:x] - 1
      end
      return [new_beam]
    when '\\'
      new_beam = {}
      case beam[:dir]
      when :north
        new_beam[:y] = beam[:y]
        new_beam[:x] = beam[:x] - 1
        new_beam[:dir] = :west
      when :east
        new_beam[:y] = beam[:y] + 1
        new_beam[:x] = beam[:x]
        new_beam[:dir] = :south
      when :south
        new_beam[:y] = beam[:y]
        new_beam[:x] = beam[:x] + 1
        new_beam[:dir] = :east
      when :west
        new_beam[:y] = beam[:y] - 1
        new_beam[:x] = beam[:x]
        new_beam[:dir] = :north
      end
      return [new_beam]
    when '/'
      new_beam = {}
      case beam[:dir]
      when :north
        new_beam[:y] = beam[:y]
        new_beam[:x] = beam[:x] + 1
        new_beam[:dir] = :east
      when :east
        new_beam[:y] = beam[:y] - 1
        new_beam[:x] = beam[:x]
        new_beam[:dir] = :north
      when :south
        new_beam[:y] = beam[:y]
        new_beam[:x] = beam[:x] - 1
        new_beam[:dir] = :west
      when :west
        new_beam[:y] = beam[:y] + 1
        new_beam[:x] = beam[:x]
        new_beam[:dir] = :south
      end
      return [new_beam]
    when '|'
      new_beams = []
      case beam[:dir]
      when :north
        new_beam = {}
        new_beam[:y] = beam[:y] - 1
        new_beam[:x] = beam[:x]
        new_beam[:dir] = beam[:dir]
        new_beams << new_beam
      when :south
        new_beam = {}
        new_beam[:y] = beam[:y] + 1
        new_beam[:x] = beam[:x]
        new_beam[:dir] = beam[:dir]
        new_beams << new_beam
      when :east
        b1 = {}
        b1[:y] = beam[:y] - 1
        b1[:x] = beam[:x]
        b1[:dir] = :north
        new_beams << b1

        b2 = {}
        b2[:y] = beam[:y] + 1
        b2[:x] = beam[:x]
        b2[:dir] = :south
        new_beams << b2
      when :west
        b1 = {}
        b1[:y] = beam[:y] - 1
        b1[:x] = beam[:x]
        b1[:dir] = :north
        new_beams << b1

        b2 = {}
        b2[:y] = beam[:y] + 1
        b2[:x] = beam[:x]
        b2[:dir] = :south
        new_beams << b2
      end
      return new_beams
    when '-'
      new_beams = []
      case beam[:dir]
      when :east
        new_beam = {}
        new_beam[:y] = beam[:y]
        new_beam[:x] = beam[:x] + 1
        new_beam[:dir] = beam[:dir]
        new_beams << new_beam
      when :west
        new_beam = {}
        new_beam[:y] = beam[:y]
        new_beam[:x] = beam[:x] - 1
        new_beam[:dir] = beam[:dir]
        new_beams << new_beam
      when :north
        b1 = {}
        b1[:y] = beam[:y]
        b1[:x] = beam[:x] - 1
        b1[:dir] = :west
        new_beams << b1

        b2 = {}
        b2[:y] = beam[:y]
        b2[:x] = beam[:x] + 1
        b2[:dir] = :east
        new_beams << b2
      when :south
        b1 = {}
        b1[:y] = beam[:y]
        b1[:x] = beam[:x] - 1
        b1[:dir] = :west
        new_beams << b1

        b2 = {}
        b2[:y] = beam[:y]
        b2[:x] = beam[:x] + 1
        b2[:dir] = :east
        new_beams << b2
      end
      return new_beams
    end
  end

  def render_visited
    s = ''
    @height.times do |y|
      @width.times do |x|
        s += if @visited[y][x].empty?
               '.'
             else
               '#'
             end
      end
      s += "\n"
    end
    s
  end

  def count_visited
    v = 0
    @height.times do |y|
      v += @visited[y].count { |c| not c.empty? }
    end
    v
  end

  def inspect
    to_s
  end

  def to_s
    s = "<#{self.class}:\n"
    @height.times do |y|
      @width.times do |x|
        s += @map[y][x].to_s
      end
      s += "\n"
    end
    s += ">"
  end
end

input = File.read('16.input').lines.map(&:strip).map(&:chars)
width = input.size
height = input[0].size

contraptions = []

height.times do |y|
  c1 = Contraption.new(input)
  c1.add_beam(y, 0, :east)
  contraptions << c1

  c2 = Contraption.new(input)
  c2.add_beam(y, width - 1, :west)
  contraptions << c2
end

width.times do |x|
  c1 = Contraption.new(input)
  c1.add_beam(0, x, :south)
  contraptions << c1

  c2 = Contraption.new(input)
  c2.add_beam(height - 1, x, :north)
  contraptions << c2
end

contraptions.each { |c| c.energize! }

largest = contraptions.max { |c1, c2| c1.count_visited <=> c2.count_visited }
print largest.count_visited, "\n"
