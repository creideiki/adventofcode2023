#!/usr/bin/env ruby

require 'ostruct'

class Number
  attr_accessor :left, :right, :up, :down, :value

  def initialize(x, y)
    @left = x
    @right = x
    @up = y
    @down = y
    @value = 0
  end

  def add_digit(digit, x, y)
    @value = @value * 10 + digit.to_i
    @right = x
  end

  def adjacent?(pos)
    pos.x >= @left - 1 and
      pos.x <= @right + 1 and
      pos.y >= @up - 1 and
      pos.y <= @down + 1
  end

  def to_s
    "<#{self.class}: #{@value}, l: #{@left}, r: #{@right}, u: #{@up}, d: #{@down}"
  end
end

input = File.read('03.input').lines.map(&:strip).map(&:chars)

numbers = []
symbols = []

input.each_with_index do |row, y|
  current_number = nil
  row.each_with_index do |char, x|
    case char
    when '.'
      current_number = nil
    when '0'..'9'
      unless current_number
        current_number = Number.new(x, y)
        numbers << current_number
      end
      current_number.add_digit(char, x, y)
    else
      current_number = nil
      pos = OpenStruct.new
      pos.x = x
      pos.y = y
      symbols << pos
    end
  end
end

parts = []
numbers.each do |num|
  parts << num if symbols.any? { |s| num.adjacent? s }
end

print parts.sum(&:value), "\n"
