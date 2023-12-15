#!/usr/bin/env ruby

def HASH(string)
  value = 0
  string.codepoints.each do |c|
    value = ((value + c) * 17) % 256
  end
  value
end

class Lens
  attr_reader :focal_length, :label

  def initialize(focal_length, label)
    @focal_length = focal_length.to_i
    @label = label
  end

  def inspect
    to_s
  end

  def to_s
    "<#{self.class}: #{@label} #{@focal_length}>"
  end
end

class Box
  def initialize(index)
    @index = index.to_i
    @lenses = []
  end

  def empty?
    @lenses.empty?
  end

  def power
    box_power = 0
    @lenses.each_with_index do |l, i|
      box_power += (@index + 1) * (i + 1) * l.focal_length
    end
    box_power
  end

  def insert(focal_length, label)
    if old_index = @lenses.index { |l| l.label == label }
      @lenses.insert(old_index, Lens.new(focal_length, label))
      @lenses.delete_at(old_index + 1)
    else
      @lenses << Lens.new(focal_length, label)
    end
  end

  def remove(label)
    @lenses.delete_if { |l| l.label == label }
  end

  def inspect
    to_s
  end

  def to_s
    s = "Box #{@index}: "
    s += @lenses.map(&:to_s).join ' '
  end
end

input = File.read('15.input').lines.map(&:strip)[0].split ','

boxes = []
256.times do |i|
  boxes << Box.new(i)
end
input.each do |instruction|
  if instruction.include? '='
    label, focal_length = instruction.split '='
    box_num = HASH label
    boxes[box_num].insert(focal_length, label)
  elsif instruction.end_with? '-'
    label = instruction.split('-')[0]
    box_num = HASH label
    boxes[box_num].remove(label)
  else
    abort "Parse error: #{instruction}"
  end
end

print boxes.map(&:power).sum, "\n"
