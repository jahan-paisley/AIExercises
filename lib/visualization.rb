=begin
This very simple example demonstrates the Gosu::Window update/draw
loop by incrementing a counter on each update, and drawing the value
on each call to draw.
=end

require 'rubygems'
require 'gosu'
require 'pry'

class Visualization < Gosu::Window

  attr :runs

  def initialize
    super(1200, 300, false)
    @runs=[]
  end

  def update
  end


  SCALE, SCALE_X= 15, 10

  def draw
    self.caption = "Distribution of Solution/Generations"
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @runs.each_with_index do |run, i|
      # puts run[:generation]
      @font.draw('.', run[:generation]*SCALE_X, 100-run[:best_fitness]*SCALE, 1, 1, 1, Gosu::Color::RED)
      @font.draw('.', run[:generation]*SCALE_X, 100-run[:avg_fitness]*SCALE, 1, 1, 1, Gosu::Color::WHITE)
    end

    @font.draw(@runs[0][:best_fitness]-0.1, @runs[0][:generation]*SCALE_X, 100-@runs[0][:best_fitness]*SCALE+50, 1, 1, 1, Gosu::Color::RED)
    @font.draw(@runs[0][:avg_fitness]-0.1, @runs[0][:generation]*SCALE_X, 100-@runs[0][:best_fitness]*SCALE+100, 1, 1, 1, Gosu::Color::WHITE)

    @font.draw(@runs[-1][:best_fitness]-0.1, @runs[-1][:generation]*SCALE_X, 100-@runs[-1][:best_fitness]*SCALE+50, 1, 1, 1, Gosu::Color::RED)
    @font.draw(@runs[-1][:avg_fitness]-0.1, @runs[-1][:generation]*SCALE_X, 100-@runs[-1][:avg_fitness]*SCALE+100, 1, 1, 1, Gosu::Color::WHITE)

  end

  def button_down(id)
    if id == Gosu::KbEscape
      close # exit on press of escape key
    end
  end

end
