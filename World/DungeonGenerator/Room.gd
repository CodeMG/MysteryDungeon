extends RigidBody2D

var size

func make_room(pos, dimension):
	position = pos
	size = dimension
	var s = RectangleShape2D.new()
	s.custom_solver_bias = 0.75
	s.size = size
	$CollisionShape2D.shape = s
	
func get_extent() -> Rect2i:
	var extent = Rect2i()
	var c = Globals.CELL_SIZE
	extent.position = Vector2i(((position-(size/2))/c).floor()*c) + Vector2i(c,c)*2
	extent.size = Vector2i((size/c).floor()*c) - Vector2i(c,c)*3
		
	return extent
