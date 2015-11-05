require "numeric"

class Exercise1
  attr_reader :popu, :elements

  def initialize pm, pc, ip, itc
    @pm, @pc, @ip, @itc= pm, pc, ip, itc
    generate
  end

  def generate
    @popu= (1..@ip).map { SecureRandom.random_number(65535) }
    @elements= []
    @elements= @popu.map { |el| Element.new(el) }
    calc_f_ratio
  end

  def calc_f_ratio
    binding.pry
    min1= @elements.map(&:fitness).min
    fit_sum = @elements.reduce(0) { |sum, el| sum+=el.fitness+min1.abs }
    @elements.each do |el|
      el.f_ratio = ((el.fitness+min1.abs)/fit_sum)
    end
    @elements.reduce(0) do |sum, el|
      sum += el.f_ratio
      el.f_ratio = sum
    end

    # min = @elements.map(&:f_ratio).min
    # @elements.each { |e| e.f_ratio+= min.abs } if min<0
  end

  def select_next
    # binding.pry
    first = SecureRandom.random_number()
    second = SecureRandom.random_number()

    sorted = @elements.sort_by { |el| el.f_ratio }
    pair1 = @elements.select { |el| el.f_ratio >= first }.first
    if pair1.nil?
      if first < sorted.map { |e| e.f_ratio }.min
        pair1= sorted.first
      elsif first > sorted.map { |e| e.f_ratio }.max
        pair1= sorted.last
      else
        raise("error in f_ratio ")
      end
    end

    pair2 = sorted.select { |el| el.f_ratio >= second }.first
    # if sorted.map { |e| e.f_ratio }.min.nil?
    #   return pair1, pair1
    # end
    if pair2.nil?
      if second < sorted.map { |e| e.f_ratio }.min
        pair2= sorted.first
      elsif second > sorted.map { |e| e.f_ratio }.max
        pair2= sorted.last
      else
        raise("error in f_ratio ")
      end
    end

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
    # binding.pry
    new_popu = []
    while new_popu.length < @ip
      a, b = select_next
      child1= crossover(a, b)
      new_popu.push(child1) #unless new_popu.include? child1
    end
    # binding.pry

    raise("population exceeded exptected value") if new_popu.length > @ip
    new_popu.each_with_index { |el, i| new_popu[i]= mutate(el) if SecureRandom.random_number() <= @pm }

    # n_best_match = best_match(new_popu)
    # if n_best_match.fitness < best_match(@elements).fitness
    #   new_popu.reject! { |e| e==worst_match(new_popu) }
    #   new_popu << n_best_match
    # end
    @elements= new_popu
  end

  def run
    @itc.times do |i|
      gibm = best_match(@elements)
      puts "best match in gen (#{i}) for x=#{gibm.x}, y= #{gibm.y}, #{gibm.fitness}."
      next_generation
    end

    mx = @elements.max { |a, b| a.fitness <=> b.fitness }
    puts "maximum value for x=#{mx.x}, y= #{mx.y}, fitness= #{mx.fitness}"
  end

  def crossover a, b
    # binding.pry
    r = SecureRandom.random_number()
    ran= SecureRandom.random_number(7)
    if r <= @pc
      a1= a.elem
      b1= b.elem

      var1 = a1.to_s(2)[0..ran] + b1.to_s(2)[ran..16]
      new_fit = Element.new(var1.to_i(2))
      a11 = new_fit if new_fit.fitness > a.fitness and new_fit.fitness > b.fitness
    end

    return a11||a
  end

  def mutate el
    r = SecureRandom.random_number(16)
    bin = el.elem.to_s(2).rjust(16, '0')
    bin[r] == 0 ? '1' : '0'
    el.elem= bin.to_i(2)
    el
  end

end

#xf 101.02824551412276
#yf 92.32139366069683
#x -0.622866
#y -0.827733
#x -3.0146556632604
#y -2.9805239391498

class Element
  attr_accessor :elem, :f_ratio, :x, :y, :fitness

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