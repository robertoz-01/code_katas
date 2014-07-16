require_relative 'test_case'

class DeadCellTest < Test::Unit::TestCase
  def test_to_s
    assert_equal '.', DeadCell.new(3, 5).to_s
  end

  def test_to_alive
    dead_cell = DeadCell.new(3, 5)
    alive_cell = dead_cell.to_alive

    assert_true alive_cell.alive?
    assert_false dead_cell.alive?
  end
end