class_name DungeonWorld extends RandomWorld

func _ready():
	super._ready()
	#world_name = "Cursed Tower"

func create_level():
	#ToDo set the level parameters here (roomcount etc.)
	generator.stair_exists = true
	#amount_of_levels = 2
	super.create_level()
	await get_tree().create_timer(1.4).timeout
	#spawn_enemy()
	spawn_lightsource()
	spawn_lightsource()
	spawn_lightsource()
	spawn_lightsource()
	spawn_lightsource()
	spawn_items()
