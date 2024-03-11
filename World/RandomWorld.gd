class_name RandomWorld extends World

#DungeonGenerator
@onready var generator = %DungeonGenerator

#Most basic create_level function
func create_level():
	if randomly_generate:
		current_level += 1
		clear_all()
		#Loading Screen
		node_loadingScreen.set_text(world_resource.name + ": " + str(current_level))
		node_loadingScreen.show()
		#ToDo set the level parameters here (roomcount etc.)
		generator.generate()
		await get_tree().create_timer(1.5).timeout
		position_player()
		await get_tree().create_timer(0.5).timeout
		node_minimap.draw_minimap()
		spawn_items()
		spawn_enemies()
		#Put all the rooms into the rooms array:
		rooms = generator.get_rooms()
		pathfinder = Globals.tilemap_to_AStarGrid2D(node_tilemap)
		node_loadingScreen.hide()
		
#Most basic position_player function
func position_player():
	var room_count = $DungeonGenerator/Rooms.get_child_count()
	var spawn_room = randi_range(0,room_count-1)
	var room = $DungeonGenerator/Rooms.get_children()[spawn_room]
	var room_position = room.position
	var room_extent = room.size
	node_player.set_pos((room_position/16).floor() * 16)

func get_stairs():
	return generator.stair_pos
