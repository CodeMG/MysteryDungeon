extends World



func create_level():
	#ToDo set the level parameters here (roomcount etc.)
	generator.set_wall(Vector2i(3,4))
	generator.set_ground(Vector2i(1,1))
	generator.set_stairs(Vector2i(9,3))
	generator.stair_exists = true
	generator.generate()
	await get_tree().create_timer(1.4).timeout
	position_player()
	spawn_enemy()
	spawn_enemy()
	spawn_enemy()
	spawn_enemy()
	spawn_enemy()
	spawn_lightsource()
	spawn_lightsource()
	spawn_lightsource()
	spawn_lightsource()
	spawn_lightsource()
	spawn_item()
	spawn_item()
	spawn_item()
	spawn_item()
	spawn_item()
	


