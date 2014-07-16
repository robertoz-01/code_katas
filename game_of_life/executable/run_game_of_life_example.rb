require_relative '../lib/world'
require_relative '../lib/alive_cell'
require_relative '../lib/dead_cell'
require_relative '../lib/textual_user_iterface'

world = World.new([AliveCell.new(0, 1), AliveCell.new(0, 2), AliveCell.new(1, 1), AliveCell.new(2, 1), AliveCell.new(1, 3)])
world.run(TextualUserIterface.new, (-10..10))