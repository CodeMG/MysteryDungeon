extends Node2D

var Room = preload("res://World/DungeonGenerator/room.tscn")
var stairs = preload("res://World/Levels/Staircase/Staircase.tscn")
@onready var Map = $"../TileMap"

#Generation
var tile_size = 32
var num_rooms = 50
var min_size = 4
var max_size = 10
var hspread = 400
var cull = 0.5

#Tiles
var ground_tile: Vector2i
var wall_tile: Vector2i
var stair_tile: Vector2i
var stair_exists: bool = true
var path
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func set_ground(tile):
	ground_tile = tile
func set_wall(tile):
	wall_tile = tile
func set_stairs(tile):
	stair_tile = tile

func generate():
	#Reset
	for room in $Rooms.get_children():
		room.free()
	#Set
	for eo in $EventObjects.get_children():
		eo.free()
	make_rooms()
	await get_tree().create_timer(1.0).timeout
	make_map()
	if stair_exists:
		place_stairs()

func make_rooms():
	for i in range(num_rooms):
		var pos = Vector2(randi_range(-hspread,hspread),0)
		var r = Room.instantiate()
		var w = min_size + randi() % (max_size-min_size)
		var h = min_size + randi() % (max_size-min_size)
		r.make_room(pos,Vector2(w,h)*tile_size)
		$Rooms.add_child(r) 
	#wait for movement to stop
	await get_tree().create_timer(0.5).timeout
	
	var room_positions = []
	for room in $Rooms.get_children():
		if randf() < cull:
			room.queue_free()
		else:
			room.freeze = true
			room_positions.append(room.position)
	await get_tree().create_timer(0.2).timeout
	path = find_mst(room_positions)
func _draw():
	
	#for room in $Rooms.get_children():
	#	draw_rect(room.get_extent(),Color(32,228,0),false)
	#if path:
	#	for p in path.get_point_ids():
	#		for c in path.get_point_connections(p):
	#			var pp = path.get_point_position(p)
	#			var cp = path.get_point_position(c)
	#			draw_line(Vector2(pp.x,pp.y),Vector2(cp.x,cp.y),Color(1,1,0),15,true)
	pass	
		
		
func _process(delta):
	queue_redraw()

func _input(event):
	#if event.is_action_pressed('ui_select'):
	#	for n in $Rooms.get_children():
	#		n.queue_free()
	#	path = null
	#	make_rooms()
	#if event.is_action_pressed('ui_focus_next'):
	#	make_map()
	pass
		
func make_map():
	#Create a Tilemap from generated rooms and path
	Map.clear()
	
	var full_rect = Rect2()
	for room in $Rooms.get_children():
		var r = Rect2(room.position-room.size*0.5,room.get_node("CollisionShape2D").shape.extents*2)
		full_rect = full_rect.merge(r)
	var topleft = Map.local_to_map(full_rect.position)
	var bottomright = Map.local_to_map(full_rect.end)
	var cells = []
	for x in range(topleft.x,bottomright.x):
		for y in range(topleft.y,bottomright.y):
			cells.append(Vector2i(x,y))
	Map.set_cells_terrain_connect(1,cells,0,1,false)
	
	var corridors = []
	for room in $Rooms.get_children():
		var s = (room.size/tile_size).floor()
		var pos = Map.local_to_map(room.position)
		var ul = pos-Vector2i(s)
		for x in range(2,s.x*2-1):
			for y in range(2,s.y*2-1):
				Map.set_cells_terrain_connect(0,[Vector2i(ul.x+x,ul.y+y)],0,2)
				#Map.set_cell(1,Vector2i(ul.x+x,ul.y+y),0,Vector2i(-1,-1))
				Map.set_cells_terrain_connect(1,[Vector2i(ul.x+x,ul.y+y)],0,-1)
		var p = path.get_closest_point(Vector2(room.position.x,room.position.y))
		
		for conn in path.get_point_connections(p):
			if not conn in corridors:
				var start = Map.local_to_map(Vector2(path.get_point_position(p).x,path.get_point_position(p).y))
				var end = Map.local_to_map(Vector2(path.get_point_position(conn).x,path.get_point_position(conn).y))
				
				carve_path(start,end)
		corridors.append(p)
		
func carve_path(pos1,pos2):
	var x_diff = sign(pos2.x - pos1.x)
	var y_diff = sign(pos2.y - pos1.y)
	if x_diff == 0: x_diff = pow(-1.0,randi()%2)
	if y_diff == 0: y_diff = pow(-1.0,randi()%2)
	
	var x_y = pos1
	var y_x = pos2
	if (randi()%2) > 0:
		x_y = pos2
		y_x = pos1
	for x in range(pos1.x,pos2.x,x_diff):
		Map.set_cells_terrain_connect(0,[Vector2i(x,x_y.y)],0,2)
		Map.set_cells_terrain_connect(1,[Vector2i(x,x_y.y)],0,-1)
	for y in range(pos1.y,pos2.y,y_diff):
		Map.set_cells_terrain_connect(0,[Vector2i(y_x.x,y)],0,2)
		Map.set_cells_terrain_connect(1,[Vector2i(y_x.x,y)],0,-1)

	
func find_mst(nodes):
	#Prim's algorithm
	var path = AStar2D.new()
	path.add_point(path.get_available_point_id(),nodes.pop_front())
	#repeat until no more nodes remain
	while nodes:
		var min_dist = INF
		var min_position = null
		var position = null
		
		for id in path.get_point_ids():
			var pos = path.get_point_position(id)
			for p2 in nodes:
				if pos.distance_to(p2) < min_dist:
					min_dist = pos.distance_to(p2)
					min_position = p2
					position = pos
		var n = path.get_available_point_id()
		path.add_point(n,min_position)
		path.connect_points(path.get_closest_point(position),n)
		nodes.erase(min_position)
	return path
	

func place_stairs():
	#where to place
	var room_count = $Rooms.get_child_count()
	var spawn_room = randi_range(0,room_count-1)
	var room = $Rooms.get_children()[spawn_room]
	var room_position = room.position
	var room_extent = room.size
	#Map.set_cell(2,Map.local_to_map(room_position),0,stair_tile)
	var node = stairs.instantiate()
	node.position = (room_position/16).floor()*16
	$EventObjects.add_child(node)

func get_room(position:Vector2)->Rect2i:
	var posInt = Vector2i(position.floor())
	for room in $Rooms.get_children():
		if room.get_extent().has_point(posInt):
			return room.get_extent()
	return Rect2i(0,0,0,0)
	
