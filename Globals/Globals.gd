extends Node

signal scene_change

#Game specific globals
var CELL_SIZE = 16

#Flags
var has_met_DungeonMaster: bool = false

#######################Events########################################
func start_DungeonWorld():
	get_tree().change_scene_to_file("res://World/World.tscn")
	scene_change.emit()



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
