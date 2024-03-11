extends Node

signal scene_change

########################Important Enums######################
enum EquipmentTypes{
	HELMET = 0,
	BACKPACK = 1,
	WEAPON1 = 2,
	WEAPON2 = 3,
	BRACELETS = 4,
	AMULET = 5,
	BODY_ARMOUR = 6,
	GLOVES = 7,
	BOOTS = 8
}

###################Important References#####################
var player:PlayerUnit

###################Important Scenes##############################
var fireball = preload("res://Skills/Fireball/Fireball.tscn")
var intro = preload("res://Cutscenes/Intro/intro.tscn")
###################Important Resources##########################
var modlist:Array[Modifier]
var skills:Array[Skill]
#######################Game specific globals#############################
var CELL_SIZE = 16

##########################Flags####################################
var has_met_DungeonMaster: bool = false

#######################Events########################################
func start_DungeonWorld():
	get_tree().change_scene_to_file("res://World/World.tscn")
	scene_change.emit()

func start_intro():
	get_tree().change_scene_to_file(intro.resource_path)
	scene_change.emit()

######################Init##############################
func _ready():
	init_modlist()
	init_skills()

func init_skills():
	var fb = FireballSkill.new()
	fb.level = 1
	fb.owner = player
	skills.append(fb)
	var sc = SoulCombustionSkill.new()
	sc.level = 1
	sc.owner = player
	skills.append(sc)

func init_modlist():
	var path = "res://Items/Modifiers/"
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			var resource = load(path+file)
			modlist.append(resource)
			file = dir.get_next()
	else:
		print("MODIFIERS LIST NOT FOUND!!!!!!!!!!!!!!!!")

#####################Helper functions######################################
func tilemap_to_AStarGrid2D(tilemap:TileMap) -> AStarGrid2D:
	var star = AStarGrid2D.new()
	star.default_compute_heuristic = AStarGrid2D.HEURISTIC_CHEBYSHEV
	star.default_estimate_heuristic = AStarGrid2D.HEURISTIC_CHEBYSHEV
	star.diagonal_mode = star.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	#First get bounding rect
	var used_rect = tilemap.get_used_rect()
	star.region = used_rect
	star.cell_size = Vector2i(CELL_SIZE,CELL_SIZE)
	star.update()
	#Iterate over it and add the walls to the star
	for x in range(star.region.position.x,star.size.x):
		for y in range(star.region.position.y,star.size.y):
			var tile = tilemap.get_cell_tile_data(1,Vector2i(x,y))
			if tile != null:
				star.set_point_solid(Vector2i(x,y),true)
	return star


#####################SAVING AND LOADING#################################
func save_progress(id:int):
	var path  = "user://savegame"+str(id)+".save"
	var save_game = FileAccess.open(path, FileAccess.WRITE)
	#Store Date and Time of saving
	save_game.store_string(Time.get_datetime_string_from_system())
	
	
	save_game.close()

func progress_exists(id:int) -> bool:
	var path  = "savegame"+str(id)+".save"
	var dir = DirAccess.open("user://")
	return dir.file_exists(path)

func delete_progress(id:int):
	var path  = "savegame"+str(id)+".save"
	var dir = DirAccess.open("user://")
	dir.remove(path)
	
func get_date_of_progress(id:int):
	var path  = "user://savegame"+str(id)+".save"
	var save_game = FileAccess.open(path, FileAccess.READ)
	if save_game == null:
		return null
	var date = save_game.get_line()
	#Time.get_datetime_dict_from_datetime_string(date,false)
	return date
