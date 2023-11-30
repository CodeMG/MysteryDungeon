@tool
extends Node2D

var waiting:bool = false

func _process(delta):
	queue_redraw()
	if !Engine.is_editor_hint():
		return
	
	#Change rooms to be in a 16 by 16 grid
	if !waiting:
		waiting = true
		await get_tree().create_timer(5.0).timeout
		waiting = false
		#print("Updating rooms")
		var world = get_parent().get_parent()
		if world.name == "World" and Engine.is_editor_hint():
			var rooms = world.rooms
			if rooms.size() != 0:
				for i in range(0,rooms.size()):
					#print("room: " + str(i) + " updated")
					rooms[i].position = (rooms[i].position/16)*16
					rooms[i].size = (rooms[i].size/16)*16
				

func _draw():
	var world = get_parent().get_parent()
	if world.name == "World" and Engine.is_editor_hint():
		var rooms = world.rooms
		if rooms.size() != 0:
			for room in rooms:
				var rect = room
				rect.position -= Vector2i(8,8)
				draw_rect(rect,Color(1,0,0),false,1)
