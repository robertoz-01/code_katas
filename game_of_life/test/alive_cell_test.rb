require_relative 'test_case'

class AliveCellTest < Test::Unit::TestCase
  def test_cell_neighbourhood_coordinates
    expected_coords = [[2, 9], [2, 10], [2, 11],
                       [3, 9], [3, 11],
                       [4, 9], [4, 10], [4, 11]]
    assert_equal expected_coords, AliveCell.new(3, 10).neighbourhood_coordinates
  end

  def test_eql?
    assert_true AliveCell.new(3, 5).eql?(AliveCell.new(3, 5))
    assert_false AliveCell.new(3, 5).eql?(AliveCell.new(33333, 5))
  end

  def test_hash
    assert_equal AliveCell.new(3, 5).hash, AliveCell.new(3, 5).hash
    assert_not_equal AliveCell.new(3, 5).hash, AliveCell.new(33333, 5).hash
  end

  def test_to_s
    assert_equal 'X', AliveCell.new(3, 5).to_s
  end
end