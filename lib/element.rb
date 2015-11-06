class Element
  attr_accessor :elem, :f_ratio, :x, :y, :fitness

  def initialize elem
    @elem= elem
    @x=x
    @y=y
  end

  def self.fit(x, y)
    e = Math::E
    (1-x)**2*e**((-x**2)-(y+1)**2)-(x-x**3-y**3)*e**(-x**2-y**2)
  end

  def eql?(other_key)
    elem == other_key.elem
  end

  def x
    @x= (@elem & 0x00FF)*0.0235294 - 3
  end

  def y
    @y=((@elem & 0xFF00) >> 8)*0.0235294 - 3
  end

  def <=>(other_key)
    fitness <=> other_key.fitness
  end

  def fitness
    x= @elem & 0x00FF
    y= (@elem & 0xFF00) >> 8
    x= x*0.0235294 - 3
    y= y*0.0235294 - 3
    Element.fit(x, y)
  end
end