class_name World extends Node2D

#CONSTANTS
const GROUND_LAYER = 0
const WALL_LAYER = 1

#exports
@export var randomly_generate:bool = true
@export var rooms:Array[Rect2i]
@export var world_resource:WorldResource

#Tilemap
@onready var node_tilemap = %TileMap
#Light
@onready var node_light = $PointLight2D
#Player
@onready var node_player = %Player
#EnemiesContainer
@onready var node_enemies = %Enemies
#NPCContainer
@onready var node_npcs = %NPCs
#Effects Container
@onready var node_effects = %Effects
#Item Container
@onready var node_items = %Items
#Loading Screen
@onready var node_loadingScreen = %LoadingScreen
#Minimap
@onready var node_minimap = %MinimapLayer/%SubViewportContainer

#Enemy
var enemy = preload("res://World/Units/Enemy/BasicEnemy/BasicEnemy.tscn")
#Torch
var torch = preload("res://World/Lighting/Torch.tscn")
#Item
var item_preset = preload("res://Items/Item.tscn")


#worldspecific

var current_level = 0
var pathfinder:AStarGrid2D

func _ready():
	GameLogic.set_world(self) #Tell the Gamelogic that this is the world currently active
	GameLogic.game_active = true #Tell the Gamelogic that we are not in the menu and that the game is running
	
func _process(delta):
	update_lighting()
	#Check if units are in light
	for e in node_enemies.get_children():
		var rect = node_light.get_rect()
		if node_light.get_rect().has_point(e.position):
			e.set_in_light(true)
		else:
			e.set_in_light(false)

func update_lighting():
	#update lighting rect
	var room = get_room(node_player.position)
	if room == Rect2i(0,0,0,0):
		room = Rect2i(node_player.position.floor().x-16,node_player.position.floor().y-16,3*16,3*16)
		node_light.change_rect(Rect2(room))
		return
	node_light.change_rect_with_boundary(Rect2(room))

func clear_all():
	#Clear stuff
	for e in node_enemies.get_children():
		e.queue_free()
	for i in node_items.get_children():
		i.queue_free()
	for e in node_effects.get_children():
		e.queue_free()
	
func spawn_enemy():
	var room_extent = get_random_room()
	var en = enemy.instantiate()
	node_enemies.add_child(en)
	var c = Globals.CELL_SIZE
	var x = randi_range(0,(room_extent.size.x/c))*c
	var y = randi_range(0,(room_extent.size.y/c))*c
	en.position = room_extent.position + Vector2i(x,y)
	en.died.connect(node_player.receive_exp)



func spawn_lightsource():
	var room_extent = get_random_room() 
	var tor = torch.instantiate()
	node_effects.add_child(tor)
	tor.name = "Torch"
	tor.position = room_extent.position
	tor = torch.instantiate()
	node_effects.add_child(tor)
	tor.name = "Torch"
	tor.position = room_extent.position + room_extent.size - Vector2i(Globals.CELL_SIZE,Globals.CELL_SIZE)

func get_random_room():
	var room_count = $DungeonGenerator/Rooms.get_child_count()
	var spawn_room = randi_range(0,room_count-1)
	var room = $DungeonGenerator/Rooms.get_children()[spawn_room]
	var room_extent = room.get_extent()
	return room_extent
	
func get_path_on_grid(start:Vector2i,end:Vector2i)-> Array:
	return pathfinder.get_point_path(start/Globals.CELL_SIZE,end/Globals.CELL_SIZE)
	
func get_room(position:Vector2)->Rect2i:
	var posInt = Vector2i(position.floor())
	for room in rooms:
		var tmp = room
		#tmp.size+=Vector2i(1,1) #Else the borders are not inclusive
		#tmp.position+=Vector2i(1,1)
		if tmp.has_point(posInt):
			return room
	return Rect2i(0,0,0,0)
	
func get_stairs():
	return null
	
	
##############Spawn functions#############################
func spawn_items():
	var array_of_items = world_resource.spawnable_items
	var total_weights = world_resource.item_weight_padding
	for item in array_of_items:
		total_weights += item.weight
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var cells = node_tilemap.get_used_cells(GROUND_LAYER)
	for cell in cells:
		var i = rng.randi_range(0,total_weights-1)
		if i < world_resource.item_weight_padding:
			continue
		var counter = world_resource.item_weight_padding
		for item in array_of_items:
			if i < counter+item.weight:
				spawn_item(item,cell*Vector2i(Globals.CELL_SIZE,Globals.CELL_SIZE))
				break
			counter += item.weight

func spawn_item(item:ItemResource, pos:Vector2i):
	var item2d = item_preset.instantiate()
	node_items.add_child(item2d)
	var final_item
	if item is EquippableItemResource:
		final_item = EquippableItem.new()
		final_item.source = item
		final_item.generate_mods()
	elif item is ConsumableItemResource:
		final_item = ConsumableItem.new()
		final_item.source = item
	item2d.set_item(final_item)
	item2d.position = pos

############### World info getters ##########################
func wall_at_pos(pos:Vector2i) -> bool:
	return !node_tilemap.get_cell_tile_data(WALL_LAYER,node_tilemap.local_to_map(pos)) == null
	
func npc_at_pos(pos:Vector2i):
	for npc in node_npcs.get_children():
		if Vector2i(npc.position.floor()) == pos:
			return npc
	return null
	
func enemy_at_pos(pos:Vector2i):
	for enemy in node_enemies.get_children():
		if Vector2i(enemy.position.floor()) == pos:
			return enemy
	return null

func player_at_pos(pos:Vector2i):
	if Vector2i(node_player.position.floor()) == pos:
		return node_player
	return null

func unit_at_pos(pos:Vector2i):
	var enemy = enemy_at_pos(pos)
	if enemy != null:
		return enemy
	var npc = npc_at_pos(pos)
	if npc != null:
		return npc
	var player = player_at_pos(pos)
	return player
