class AliveCell
  def initialize(x, y)
    @x, @y = x, y
  end

  def neighbourhood_coordinates
    coordinates = []
    (-1..+1).each do |x_offset|
      (-1..+1).each do |y_offset|
        coordinates << [@x+x_offset, @y+y_offset]
      end
    end
    coordinates.reject { |x, y| @x==x && @y==y }
  end

  def is_at?(x, y)
    @x == x && @y == y
  end

  def alive?
    true
  end

  def ==(cell)
    cell.instance_eval { @x } == @x && cell.instance_eval { @y } == @y
  end

  def eql?(cell)
    self == cell
  end

  def hash
    @x.hash ^ @y.hash
  end

  def to_s
    'X'
  end

  def inspect
    "#{self.class.name} x:#{@x} y:#{@y}"
  end
end