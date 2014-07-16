class TextualUserIterface
  def write(str)
    $stdout.print str
    $stdout.flush
  end

  alias write_cell write

  def write_new_row
    $stdout.write("\n")
  end

  def read
    $stdin.gets
  end
end