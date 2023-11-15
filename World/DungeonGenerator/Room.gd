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
	extent.position = Vector2i(((position - (size/2))/16).floor()*16) + Vector2i(3*16,3*16)
	extent.end = Vector2i(((position + (size/2))/16).floor()*16) 
	return extent
