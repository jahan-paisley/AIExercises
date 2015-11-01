require "numeric"

class Exercise1
  attr_reader :popu, :elements

  def initialize pm, pc, ip, itc
    @pm, @pc, @ip, @itc= pm, pc, ip, itc
    generate
  end

  def generate
    @popu= (0..@ip).map { Random.rand(0..65535) }
    @elements= []
    @elements= @popu.map { |el| Element.new(el) }
    calc_f_ratio
  end

  def calc_f_ratio
    fit_sum = @elements.reduce(0) { |sum, el| sum+=el.fitness }
    @elements.each do |el|
      el.f_ratio = el.fitness/fit_sum
    end
  end

  def select_pair
    # binding.pry
    first = Random.rand()
    second = Random.rand()
    @selected ||= []
    sorted = @elements.sort_by { |el| el.f_ratio }
    pair1 = sorted.select { |el| el.f_ratio >= first }.first
    if pair1.nil?
      if first < sorted.map { |e| e.f_ratio }.min
        pair1= sorted.first
      elsif first > sorted.map { |e| e.f_ratio }.min
        pair1= sorted.last
      else
        raise("error in f_ratio ")
      end
    end
    @selected << pair1
    sorted2 = sorted.reject { |el| @selected.include?(el) }
    pair2 = sorted2.select { |el| el.f_ratio >= second }.first
    if sorted2.map { |e| e.f_ratio }.min.nil?
      return pair1, pair1
    end
    if pair2.nil?
      if second < sorted2.map { |e| e.f_ratio }.min
        pair2= sorted2.first
      elsif second > sorted2.map { |e| e.f_ratio }.min
        pair2= sorted2.last
      else
        raise("error in f_ratio ")
      end
    end

    @selected << pair2
    binding.pry if pair1.nil? or pair2.nil?
    return pair1, pair2
  end

  def best_match pop
    pop.max { |a, b| a.fitness <=> b.fitness }
  end

  def worst_match pop
    pop.min { |a, b| a.fitness <=> b.fitness }
  end

  def next_generation
    new_popu = []
    while new_popu.length < @ip
      a, b = select_pair
      child1, child2= crossover(a, b)
      new_popu.push(child1, child2)
    end
    raise("population exceeded exptected value") if new_popu.length > @ip
    # binding.pry
    new_popu.each_with_index { |el, i| new_popu[i]= mutate(el) if Random.rand() <= @pm }
    # binding.pry if new_popu.nil?
    n_best_match = best_match(new_popu)
    if n_best_match.fitness < best_match(@elements).fitness
      new_popu.reject! { |e| e==worst_match(new_popu) }
      new_popu << n_best_match
    end
    @selected= []
    @elements= new_popu
  end

  def run
    @itc.times do |i|
      puts "best match in gen (#{i}): #{best_match(@elements).fitness}."
      next_generation
    end

    mx = @elements.max { |a, b| a.fitness <=> b.fitness }
    puts "maximum value is x=#{mx.x}, y= #{mx.y}, fitness= #{mx.fitness}"
  end

  def crossover a, b
    r = Random.rand()
    if r <= @pc
      a1= a.elem
      b1= b.elem
      var1 = a1 & ("01" * 8).to_i(2)
      var2 = b1 & ("10" * 8).to_i(2)
      new_fit = Element.new(var1+var2)
      a11 = new_fit if new_fit.fitness > a.fitness and new_fit.fitness > b.fitness

      var1 = a1 & ("10" * 8).to_i(2)
      var2 = b1 & ("01" * 8).to_i(2)
      new_fit = Element.new(var1+var2)
      b11 = new_fit if new_fit.fitness > a.fitness and new_fit.fitness > b.fitness
      # b11 = Element.new(a1 & 0x0F00 + b1&0x00FF)
      # a11= a11.fitness> a.fitness ? a11 : a;
      # b11= b11.fitness> b.fitness ? b11 : b;
    end
    # binding.pry if a11.nil? or b11.nil?
    return a11||a, b11||b
  end

  def mutate el
    binding.pry if el.nil?
    r = Random.rand(16)
    bin = el.elem.to_s(2).rjust(16, '0')[r]= el.elem.to_s(2).rjust(16, '0')
    bin[r] == 0 ? '1' : '0'
    el.elem= bin.to_i(2)
    el
  end

end

#xf 101.02824551412276
#yf 92.32139366069683

class Element
  attr_accessor :elem, :f_ratio, :x, :y

  def initialize elem
    @f_ratio = 0
    @elem= elem
    @x=x
    @y=y
  end

  def self.fit(x, y)
    e = Math::E
    (1-x)**2*e**((-x**2)-(y+1)**2)-(x-x**3-y**3)*e**(-x**2-y**2)
  end

  def x
    @x= (@elem & 0x00FF)*0.0235294 - 3
  end

  def y
    @y=((@elem & 0xFF00) >> 8)*0.0235294 - 3
  end

  def fitness
    x= @elem & 0x00FF
    y= (@elem & 0xFF00) >> 8
    x= x*0.0235294 - 3
    y= y*0.0235294 - 3
    Element.fit(x, y)
  end
end