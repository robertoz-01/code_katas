class DeadCell < AliveCell
  def alive?
    false
  end

  def to_s
    '.'
  end

  def to_alive
    AliveCell.new(@x, @y)
  end
end