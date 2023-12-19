#!/usr/bin/env ruby

class Rule
  def initialize(target)
    @target = target
  end

  def run(part)
    if match? part
      @target
    else
      nil
    end
  end

  def match?(part) end
end

class Terminal_Rule < Rule
  attr_reader :target

  def initialize(rule)
    super(rule)
  end

  def match?(part)
    true
  end

  def inspect
    to_s
  end

  def to_s
    "<#{self.class} #{@target}>"
  end
end

class Conditional_Rule < Rule
  attr_reader :var, :val, :oper, :target

  def initialize(rule)
    conditional_rule_format = /^(?<var>[xmas])(?<oper>[<>])(?<val>[[:digit:]]+):(?<target>[[:alpha:]]+)$/
    m = conditional_rule_format.match rule
    @var = m['var'].to_s
    @oper = m['oper'].to_s
    @val = m['val'].to_i
    super(m['target'])
  end

  def match?(part)
    part.send(@var).send(@oper, @val)
  end

  def inspect
    to_s
  end

  def to_s
    "<#{self.class} #{@var}#{@oper}#{@val}: #{@target}>"
  end
end

class Workflow
  attr_reader :name, :rules

  def initialize(name, rules)
    @name = name
    @rules = []
    rules.each do |rule|
      if rule.include? ':'
        @rules << Conditional_Rule.new(rule)
      else
        @rules << Terminal_Rule.new(rule)
      end
    end
  end

  def run(part)
    @rules.each do |rule|
      next unless rule.match? part

      result = rule.run part
      if result == 'A'
        part.verdict = true
        return nil
      elsif result == 'R'
        part.verdict = false
        return nil
      else
        return result
      end
    end
  end

  def inspect
    to_s
  end

  def to_s
    s = "<#{self.class} #{name}: "
    s += @rules.join ', '
    s += '>'
  end
end

class Part
  attr_reader :x, :m, :a, :s
  attr_accessor :verdict

  def initialize(x, m, a, s)
    @x = x.to_i
    @m = m.to_i
    @a = a.to_i
    @s = s.to_i
    @verdict = nil
  end

  def score
    @x + @m + @a + @s
  end

  def inspect
    to_s
  end

  def to_s
    "<#{self.class} x=#{@x} m=#{@m} a=#{@a} s=#{@s} (#{@verdict})>"
  end
end

input = File.read('19.input').lines.map(&:strip)

workflow_format = /^(?<name>[[:alpha:]]+){(?<rules>[^}]+)}$/
workflows = {}

until (line = input.shift).empty?
  m = line.match workflow_format
  workflows[m['name']] = Workflow.new(m['name'], m['rules'].split(','))
end

part_format = /^{x=(?<x>[[:digit:]]+),m=(?<m>[[:digit:]]+),a=(?<a>[[:digit:]]+),s=(?<s>[[:digit:]]+)}$/
parts = []

input.each do |line|
  m = line.match part_format
  parts << Part.new(m['x'], m['m'], m['a'], m['s'])
end

parts.each do |part|
  workflow = workflows['in']
  loop do
    result = workflow.run part
    break if result.nil?
    workflow = workflows[result]
  end
end

print parts.select { |p| p.verdict }.sum(&:score), "\n"
