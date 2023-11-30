extends Node2D

@onready var tilemap = %TileMap
@onready var tilemap_ref = %TileMap2
#func _ready():
#	var arr = tilemap_ref.get_used_cells(0)
#	for v in arr:
#		#tilemap.set_cell(0,v,0,Vector2(1,1))
#		pass
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		var arr = tilemap_ref.get_used_cells(0)
		for v in arr:
			tilemap.set_cells_terrain_connect(0,[v],0,0)
			await get_tree().create_timer(0.001).timeout
