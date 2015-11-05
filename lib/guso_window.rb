=begin
This very simple example demonstrates the Gosu::Window update/draw
loop by incrementing a counter on each update, and drawing the value
on each call to draw.
=end

require 'gosu'
require 'pry'

class GameWindow < Gosu::Window

  def initialize points
    @points= points
    super(1000, 1000, false)
    self.caption = "P1 of Math for CS"
    @color = [Gosu::Color::GRAY, Gosu::Color::AQUA,
              Gosu::Color::RED, Gosu::Color::GREEN,
              Gosu::Color::YELLOW, Gosu::Color::FUCHSIA,
              Gosu::Color::CYAN].sample
    # we load the font once during initialize, much faster than
    # loading the font before every draw
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
  end

  def update
  end

  BEL_MARG, SCALE, FONT_SCALE= 150, 100, 1

  def draw
    y=5
    @points.each do |parray|
      len = (parray[0].length-1)
      (0...len).each do |index|
        x1 = parray[0][index]
        x2 = parray[1][index]
        nextx1 = parray[0][index+1]
        @font.draw(x1, x1*SCALE, y-5, 1, FONT_SCALE)
        @font.draw(x2, x2*SCALE, y-5+BEL_MARG, 1, FONT_SCALE)
        draw_line(x1*SCALE, y, @color, x2*SCALE, y+BEL_MARG, @color)

        @font.draw(nextx1, nextx1*SCALE, y-5, 1, FONT_SCALE)
        draw_line(x2*SCALE, y+BEL_MARG, @color, nextx1*SCALE, y, @color)
      end
      y=y+250
    end

  end

  def button_down(id)
    if id == Gosu::KbEscape
      close # exit on press of escape key
    end
  end

end
