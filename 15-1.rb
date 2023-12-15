#!/usr/bin/env ruby

class HASH
  attr_accessor :value

  def initialize(string)
    @string = string
    @value = 0
    string.codepoints.each do |c|
      @value = ((@value + c) * 17) % 256
    end
  end
end

strings = File.read('15.input').lines.map(&:strip)[0].split ','
print strings.map { |s| HASH.new s }.sum(&:value), "\n"
