#!/usr/bin/env ruby

class Network
  attr_reader :gates

  def initialize(input)
    gate_format = /^(?<name>[[:alpha:]&%]+) -> (?<outputs>.*)$/
    @gates = {}

    input.each do |line|
      m = line.match gate_format
      outputs = m['outputs'].split(',').map(&:strip)
      if m['name'] == 'broadcaster'
        name = m['name']
        gate = Broadcaster.new(name, outputs)
      elsif m['name'].start_with? '%'
        name = m['name'][1..]
        gate = Flip_Flop.new(name, outputs)
      elsif m['name'].start_with? '&'
        name= m['name'][1..]
        gate = Conjunction.new(name, outputs)
      else
        abort "Unknown gate type #{m['name']}"
      end
      @gates[name] = gate
    end

    @gates.each_value do |g|
      g.outputs.each do |o|
        @gates[o].connect_input g.name if @gates.include? o
      end
    end

    @button_presses = 0
  end

  def score
    (@button_presses +
     gates.values.map { |g| g.pulses[:low] }.reduce(&:+)) *
      gates.values.map { |g| g.pulses[:high] }.reduce(&:+)
  end

  def step(queue)
    source, target, signal = queue.shift
    if @gates.include? target
      queue + @gates[target].receive(source, signal)
    else
      queue
    end
  end

  def push_button!
    @button_presses += 1
    queue = [['button', 'broadcaster', :low]]
    queue = step(queue) until queue.empty?
  end
end

class Gate
  attr_reader :name, :inputs, :outputs, :pulses

  def initialize(name, outputs)
    @name = name
    @outputs = outputs
    @inputs = {}
    @pulses = Hash.new 0
  end

  def connect_input(name)
    @inputs[name] = nil
  end

  def receive(input, signal) end

  def send(signal)
    res = []
    @outputs.each do |o|
      res << [@name, o, signal]
      @pulses[signal] += 1
    end
    res
  end

  def inspect
    to_s
  end

  def to_s
    "<#{self.class}: #{@name} -> #{@outputs.join ', '}>"
  end
end

class Broadcaster < Gate
  def receive(input, signal)
    send signal
  end
end

class Flip_Flop < Gate
  def initialize(name, outputs)
    super
    @state = :off
  end

  def connect_input(name)
    @inputs[name] = :low
  end

  def receive(input, signal)
    return [] if signal == :high

    @inputs[input] = signal
    case @state
    when :off
      @state = :on
      return send :high
    when :on
      @state = :off
      return send :low
    end
    res
  end
end

class Conjunction < Gate
  def connect_input(name)
    @inputs[name] = :low
  end

  def receive(input, signal)
    @inputs[input] = signal

    if @inputs.values.all? :high
      return send :low
    else
      return send :high
    end
  end
end

input = File.read('20.input').lines.map(&:strip)

net = Network.new(input)
1_000.times { |_| net.push_button! }
print net.score, "\n"
