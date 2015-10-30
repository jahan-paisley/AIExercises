require "numeric"

class Exercise1
  attr_reader :popu

  def self.fitness(x, y)
    e = Math::E
    (1-x)^2*e^((-x^2)-(y+1)^2)-(x-x^3-y^3)*e^(-x^2-y^2)
  end

  def initialize pm, pc, ip, itc
    @pm, @pc, @ip, @itc= pm, pc, ip, itc
    generate
  end

  def generate
    @popu= (0..@ip).map { Random.rand(0..255) }
    @popu_f= @popu.map{|e| fitness(e&0xFF00, e&0x00FF)}
  end

  def next_generation
    new_popu= []
    @popu.combination(2) do |a, b|
      child = crossover(a, b)
      if fit?(child)
        new_popu << child
      else
        new_popu.push([a, b)
      end
    end
    @popu=@popu.map { |e| @pm >= Random.rand() ? mutate(e) : e }

  end

end

