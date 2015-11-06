require "AI_exercise1/version"
require_relative 'element.rb'

module AIExercise1

  #xf 101.02824551412276
  #yf 92.32139366069683
  #x -0.622866
  #y -0.827733
  #x -3.0146556632604
  #y -2.9805239391498

  class Exercise1
    attr_reader :popu, :elements

    def initialize pm, pc, ip, itc
      @pm, @pc, @ip, @itc= pm, pc, ip, itc
      generate
    end

    def generate
      @popu= (1..@ip).map { grand(65535) }
      @elements= Set.new
      @elements= @popu.map { |el| Element.new(el) }
      calc_f_ratio
    end

    def calc_f_ratio
      min1= @elements.map(&:fitness).min
      fit_sum = @elements.reduce(0) { |sum, el| sum+=el.fitness+min1.abs }
      fit_sum = @elements.reduce(0.0000000000000001) { |sum, el| sum+=el.fitness+min1.abs } if fit_sum == 0
      @elements.each do |el|
        el.f_ratio = ((el.fitness+min1.abs)/fit_sum)
      end
      @elements.reduce(0) do |sum, el|
        sum += el.f_ratio
        el.f_ratio = sum
      end
    end

    def roll()
      ran = grand()
      s_elems = @elements.sort_by { |el| el.f_ratio }
      chosen = s_elems.find { |el| el.f_ratio >= ran }
      if chosen.nil?
        f_ratios = s_elems.map(&:f_ratio)
        if ran < f_ratios.min
          chosen= s_elems.first
        elsif ran > f_ratios.max
          chosen= s_elems.last
        else
          raise('selection got a problem')
        end
      end
      chosen
    end

    def best_match pop
      pop.max { |a, b| a.fitness <=> b.fitness }
    end

    def worst pop
      pop.min { |a, b| a.fitness <=> b.fitness }
    end

    def grand(seed= nil)
      seed ? SecureRandom.random_number(seed) : SecureRandom.random_number()
    end

    def next_generation
      np= SortedSet.new
      while np.length < @ip
        a, b = roll(), roll()
        ch1, ch2= crossover(a, b)
        np.add(ch1) #unless np.include? ch1
        np.add(ch2) #unless np.include? ch1
      end
      np.reject! { |e| e == worst(np) } if np.length > @ip

      best = best_match(elements)
      newbest= best_match(np)
      r = rand(@ip)
      np << mutate(np.to_a[r]) if grand() <= @pm

      np << best unless np.include?(best)
      np << newbest unless np.include?(newbest)

      np.reject! { |e| e == worst(np) } while np.length > @ip
      @elements= np
      calc_f_ratio
    end

    def run
      max = 0
      @itc.times do |i|
        gibm = best_match(@elements)
        max = max < gibm.fitness ? gibm.fitness : max
        puts "best match in gen (#{i}) for x=#{gibm.x}, y= #{gibm.y}, #{gibm.fitness}."
        next_generation
      end

      mx = @elements.max { |a, b| a.fitness <=> b.fitness }
      puts "best match ever: #{max}"
      puts "maximum value for x=#{mx.x}, y= #{mx.y}, fitness= #{mx.fitness}"
    end

    def crossover a, b
      r = grand()
      ran= grand(7)
      if r <= @pc
        a1= a.elem
        b1= b.elem
        var1 = a1.to_s(2)[0..ran] + b1.to_s(2)[ran..16]
        var2 = b1.to_s(2)[0..ran] + a1.to_s(2)[ran..16]
        element_new = Element.new(var1.to_i(2))
        a11 = element_new if element_new.fitness > a.fitness and element_new.fitness > b.fitness
        new = Element.new(var2.to_i(2))
        b11 = new if new.fitness > a.fitness and new.fitness > b.fitness

      end

      return a11||a, b11||b
    end

    def mutate el
      r = grand(15)
      r1 = grand(15)
      bin = el.elem.to_s(2).rjust(16, '0')
      bin[r]= bin[r] == '0' ? '1' : '0'
      el.elem = bin.to_i(2)
      el
    end

  end
end
