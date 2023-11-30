extends SubViewportContainer

@export var cell_size:int = 1

@onready var tilemap:TileMap = $"../../TileMap"
@onready var world = $"../../"

@onready var minimap:TileMap = %Minimap
@onready var camera:Camera2D = %Camera2D
var last_light_rect:Rect2
var light_ref = preload("res://UI/Minimap/minimap_light.tscn")
var occluder_ref = preload("res://UI/Minimap/minimap_occluder.tscn")
func _ready():
	GameLogic.action_performed.connect(draw_POI)

func draw_POI():
	update_minimap()
	minimap.clear_layer(1)
	var playerpos = world.node_player.position/16
	minimap.set_cells_terrain_connect(1,[Vector2i(playerpos)],0,3)
	#Enemies
	var Enemies = world.node_enemies
	var points = []
	for e in Enemies.get_children():
		points.append(e.position/16)
	minimap.set_cells_terrain_connect(1,points,0,3)
	#Stairs
	var stairs = world.get_stairs()
	if stairs == null:
		return
	stairs /= 16
	minimap.set_cells_terrain_connect(1,[stairs],0,4)
	
	

func update_minimap():
	var arr = tilemap.get_used_cells(0)
	var light = world.node_light.get_rect()
	if light == last_light_rect:
		return
	last_light_rect = light
	light.position/=Vector2(16,16)
	light.size /= Vector2(16,16)
	#light.position -= Vector2(1,1)
	#light.size += Vector2(1,1)
	var counter = 0
	var arr2 = []
	for v in arr:
		if light.has_point(v):
			counter+=1
			arr2.append(v)
			#minimap.set_cells_terrain_connect(0,[v],0,0)
			#minimap.set_cells_terrain_path(0,[v],0,0)
			#await get_tree().create_timer(0.01).timeout
			#minimap.set_cell(0,v,0,Vector2i(0,4))
	minimap.set_cells_terrain_connect(0,arr2,0,0)

func draw_minimap():
	minimap.clear()
	var arr = tilemap.get_used_cells(0)
	#minimap.set_cells_terrain_connect(0,arr,0,0)
	#Create the blocking tiles
	for room in world.rooms:
		var rect = room
		rect.position /= Vector2i(16,16)
		for x in range(room.size.x/16):
			for y in range(room.size.y/16):
				minimap.set_cell(0,rect.position+ Vector2i(x,y),1,Vector2i(4,4))
				arr.erase(Vector2i(room.position.x/16+x,room.position.y/16+y))
	for v in arr:
		var rect = Rect2i()
		rect.position = v*Vector2i(16,16)
		rect.size = Vector2i(16,16)
		minimap.set_cell(0,v,1,Vector2i(4,4))
	camera.adjust_to_tilemap()
