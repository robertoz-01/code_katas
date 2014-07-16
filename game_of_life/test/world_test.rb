require_relative 'test_case'

class WorldTest < Test::Unit::TestCase
  def test_initial_state
    world = World.new([AliveCell.new(2, 5)])
    assert_true world.cell_at(2, 5).alive?
    assert_false world.cell_at(2, 6).alive?
  end

  def test_run
    user_inferface = stub('user_inferface') do
      expects(:write_cell).times(21*21)
      expects(:write_new_row).times(21)
      expects(:write).with('next tick?').once
      expects(:read).once
    end

    world = World.new([AliveCell.new(0, 0), AliveCell.new(1, 0)])
    stop_loop_exception = RuntimeError.new('stop infinite loop!')
    world.expects(:next_tick).throws(stop_loop_exception)

    assert_throws(stop_loop_exception){ world.run(user_inferface, (-10..10))}
  end

  def test_alive_neighbourhood
    central_cell = AliveCell.new(2, 5)
    neighbour_cells = [AliveCell.new(2, 4), AliveCell.new(3, 4)]
    world = World.new([central_cell, *neighbour_cells])
    assert_equal neighbour_cells, world.alive_neighbourhood(central_cell)
  end

  def test_cell_dies_for_underpopulation
    world = World.new([AliveCell.new(2, 5)])
    world.next_tick
    assert_false world.cell_at(2, 5).alive?
  end

  def test_cell_dies_for_overcrowding
    world = World.new([AliveCell.new(2, 5), AliveCell.new(3, 5), AliveCell.new(1, 5), AliveCell.new(2, 6), AliveCell.new(2, 4)])
    world.next_tick
    assert_false world.cell_at(2, 5).alive?
  end

  def test_cell_keeps_living
    world = World.new([AliveCell.new(1, 5), AliveCell.new(2, 5), AliveCell.new(3, 5)])
    world.next_tick
    assert_true world.cell_at(2, 5).alive?
  end

  def test_cell_birth
    world = World.new([AliveCell.new(2, 5), AliveCell.new(3, 5), AliveCell.new(4, 5)])
    world.next_tick
    assert_false world.cell_at(5, 6).alive?
    assert_true world.cell_at(3, 6).alive?
  end

  def test_deaths_in_tick_are_atomic
    world = World.new([AliveCell.new(2, 4), AliveCell.new(3, 4),
                       AliveCell.new(2, 5), AliveCell.new(3, 5),
                       AliveCell.new(2, 6)])
    world.next_tick
    assert_true world.cell_at(2, 6).alive?
  end

  def test_cells_instances_is_constant_for_stable_world_configuration
    world = World.new([AliveCell.new(1, 3), AliveCell.new(2, 3), AliveCell.new(3, 3)])
    assert_eventually_do_not_grow(10.times){ next_tick_cell_instances_count(world) }
  end

  def next_tick_cell_instances_count(world)
    world.next_tick
    GC.start
    cell_instances = ObjectSpace.each_object(AliveCell)
    cell_instances.count
  end

  def assert_eventually_do_not_grow(limit, &block)
    results = limit.map{ block.call }
    assert_true(results[-1] == results[-2] && results[-2] == results[-3])
  end
end