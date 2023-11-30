extends PointLight2D
var current_rect



func change_rect(rect:Rect2):
	current_rect = rect
	current_rect.position -= Vector2(Globals.CELL_SIZE/2,Globals.CELL_SIZE/2)
	self.position = (rect.position - Vector2(Globals.CELL_SIZE/2,Globals.CELL_SIZE/2)) + rect.size*0.5
	self.scale = rect.size/Vector2(Globals.CELL_SIZE,Globals.CELL_SIZE)
	
	#if (int(rect.size.x)/16)%2 == 1:
	#	self.position.x += 16
	#	self.scale.x -= 2
	#if (int(rect.size.y)/16)%2 == 1:
	#	self.position.y += 16
	#	self.scale.y -= 2
	#self.position -= Vector2(Globals.CELL_SIZE,Globals.CELL_SIZE)
	#self.scale += Vector2(4,4)
	

func change_rect_with_boundary(rect:Rect2):
	rect.size += Vector2(Globals.CELL_SIZE,Globals.CELL_SIZE)*2
	rect.position -= Vector2(Globals.CELL_SIZE,Globals.CELL_SIZE)
	change_rect(rect)

func get_rect():
	return current_rect
