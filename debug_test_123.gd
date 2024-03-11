extends Control



func _draw():
	pass
	for i in %Nodes.get_children():
		draw_circle(i.position,5,Color.RED)
	
func _process(delta):
	queue_redraw()
