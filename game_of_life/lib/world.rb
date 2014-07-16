require 'set'

class World
  def initialize(alive_cells)
    @alive_cells = alive_cells
  end

  def run(user_interface, size)
    while true do
      size.to_a.reverse.each do |y|
        size.to_a.reverse.each do |x|
          user_interface.write_cell(cell_at(x, y))
        end
        user_interface.write_new_row
      end
      user_interface.write('next tick?')
      user_interface.read
      next_tick
    end
  end

  def cell_at(x, y)
    alive_cell = @alive_cells.detect { |c| c.is_at?(x, y) }
    alive_cell || DeadCell.new(x, y)
  end

  def next_tick
    @next_alive_cells = Set.new(@alive_cells)
    kill_for_overcrowding
    kill_for_underpopulation
    birth_for_3_neighbours
    @alive_cells = @next_alive_cells
  end

  def kill_for_overcrowding
    @next_alive_cells.delete_if { |c| alive_neighbourhood(c).count > 3 }
  end

  def kill_for_underpopulation
    @next_alive_cells.delete_if { |c| alive_neighbourhood(c).count < 2 }
  end

  def birth_for_3_neighbours
    for_each_near_dead_cell do |dead_cell|
      if alive_neighbourhood(dead_cell).count == 3
        @next_alive_cells << dead_cell.to_alive
      end
    end
  end

  def for_each_near_dead_cell(&block)
    @alive_cells.each do |alive_cell|
      dead_neighbourhood(alive_cell).each do |dead_cell|
        block.call(dead_cell)
      end
    end
  end

  def alive_neighbourhood(cell)
    neighbourhood(cell, alive: true)
  end

  def dead_neighbourhood(cell)
    neighbourhood(cell, alive: false)
  end

  def neighbourhood(cell, alive:)
    cells = []
    cell.neighbourhood_coordinates.each do |x, y|
      neighbour_cell = cell_at(x, y)
      cells << neighbour_cell if neighbour_cell.alive? == alive
    end
    cells
  end
end
