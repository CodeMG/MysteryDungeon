extends Node2D

func _draw():
	if Input.is_action_just_pressed("show_grid"):
		var rect = get_parent().get_used_rect()
		rect.position *= Vector2i(Globals.CELL_SIZE,Globals.CELL_SIZE)
		for x in range(0,rect.size.x):
			for y in range(0,rect.size.y):
				var cell_rect = Rect2()
				cell_rect.position = Vector2(rect.position.x + x*Globals.CELL_SIZE,rect.position.y + y*Globals.CELL_SIZE)
				cell_rect.size = Vector2(Globals.CELL_SIZE,Globals.CELL_SIZE)
				draw_rect(cell_rect,Color(0.2,0.3,0),false)
func _process(delta):
	if Input.is_action_just_pressed("show_grid"):
		queue_redraw()
	elif Input.is_action_just_released("show_grid"):
		queue_redraw()
