=begin
This very simple example demonstrates the Gosu::Window update/draw
loop by incrementing a counter on each update, and drawing the value
on each call to draw.
=end

require 'rubygems'
require 'gosu'
require 'pry'

class Visualization1 < Gosu::Window

  attr :runs

  def initialize result= nil
    super(1500, 1000, false)
    @runs=result
  end


  def update
  end

  SCALE= 15
  TOP_MARGIN = 500

  def draw
    self.caption = "Distribution of Solution/Generations"
    @font = Gosu::Font.new(self, Gosu::default_font_name, 10)
    (0..@runs.map { |e| e[:itc] }.max*SCALE).step(SCALE).each_cons(2) { |e|
      draw_line(e[0], TOP_MARGIN, Gosu::Color::YELLOW, e[1], TOP_MARGIN, Gosu::Color::RED)
      @font.draw(e[0]/SCALE, e[0], TOP_MARGIN, 1)
    }

    (0..@runs.map { |e| e[:success] }.max*SCALE).step(SCALE).each_cons(2) { |e|
      draw_line(2, TOP_MARGIN-e[0], Gosu::Color::YELLOW, 2, TOP_MARGIN-e[1], Gosu::Color::RED)
      @font.draw(e[0]/SCALE, 1, TOP_MARGIN-e[0], 1)
    }

    @runs.each_with_index { |el, i|
      draw_line(el[:itc]*SCALE, TOP_MARGIN-(el[:success]*SCALE), Gosu::Color::YELLOW,
                @runs[i+1][:itc]*SCALE, TOP_MARGIN-(@runs[i+1][:success]*SCALE), Gosu::Color::RED) if i<@runs.length-1
    }

    @font.draw("first gen succ rate:#{@runs[0][:success]}", @runs[0][:itc]*SCALE, TOP_MARGIN-@runs[0][:success]*SCALE, 1, 1, 1, Gosu::Color::WHITE)
    @font.draw("last gen succ rate:#{@runs[-1][:success]}", @runs[-1][:itc]*SCALE, TOP_MARGIN-@runs[-1][:success]*SCALE, 1, 1, 1, Gosu::Color::WHITE)
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close # exit on press of escape key
    end
  end

end
