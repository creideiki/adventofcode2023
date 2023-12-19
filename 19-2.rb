#!/usr/bin/env ruby

class Rule
  def initialize(target)
    @target = target
  end

  def run(part)
    parts = split part

    res = []
    parts.each do |p|
      if match? p
        res << [@target, p]
      else
        res << [:next, p]
      end
    end
    res
  end

  def split(part) end
end

class Terminal_Rule < Rule
  attr_reader :target

  def initialize(rule)
    super(rule)
  end

  def split(part)
    [part]
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

  def split(part)
    in_low = part.send(@var + '_low')
    in_high = part.send(@var + '_high')
    new_parts = []
    case @oper
    when '>'
      if @val >= in_low and @val < in_high
        p1 = part.dup
        p1.send(@var + '_high=', @val)
        new_parts << p1
        p2 = part.dup
        p2.send(@var + '_low=', @val + 1)
        new_parts << p2
      else
        new_parts << part
      end
    when '<'
      if @val > in_low and @val <= in_high
        p1 = part.dup
        p1.send(@var + '_high=', @val - 1)
        new_parts << p1
        p2 = part.dup
        p2.send(@var + '_low=', @val)
        new_parts << p2
      else
        new_parts << part
      end
    end
    new_parts
  end

  def match?(part)
    part.send(@var + '_low').send(@oper, @val)
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

  def run(parts)
    out = []
    @rules.each do |r|
      next_parts = []
      parts.each do |p|
        queue = p[0]
        part = p[1]

        if queue != :next and queue != @name
          out << p
          next
        end

        new = r.run part
        next_parts += new
      end
      parts = next_parts
    end
    out += parts
    out.each do |p|
      case p[0]
      when 'A'
        p[1].verdict = true
      when 'R'
        p[1].verdict = false
      end
    end
    out
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
  attr_accessor :x_low, :x_high
  attr_accessor :m_low, :m_high
  attr_accessor :a_low, :a_high
  attr_accessor :s_low, :s_high
  attr_accessor :verdict

  def initialize()
    @x_low = 1
    @x_high = 4_000
    @m_low = 1
    @m_high = 4_000
    @a_low = 1
    @a_high = 4_000
    @s_low = 1
    @s_high = 4_000
    @verdict = nil
  end

  def score
    (@x_high - @x_low + 1) *
      (@m_high - @m_low + 1) *
      (@a_high - @a_low + 1) *
      (@s_high - @s_low + 1)
  end

  def inspect
    to_s
  end

  def to_s
    "<#{self.class} x=#{@x_low}-#{@x_high} m=#{@m_low}-#{@m_high} a=#{@a_low}-#{@a_high} s=#{@s_low}-#{@s_high} (#{@verdict})>"
  end
end

input = File.read('19.input').lines.map(&:strip)

workflow_format = /^(?<name>[[:alpha:]]+){(?<rules>[^}]+)}$/
workflows = {}

until (line = input.shift).empty?
  m = line.match workflow_format
  workflows[m['name']] = Workflow.new(m['name'], m['rules'].split(','))
end

active = [['in', Part.new]]
finished = []
until active.empty?
  res = []
  active.each do |p|
    res += workflows[p[0]].run [p]
  end
  active, done = res.partition { |p| p[1].verdict.nil? }
  finished += done
end

print finished.select { |f| f[1].verdict }.sum { |f| f[1].score }, "\n"
