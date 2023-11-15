class_name World extends Node


#DungeonGenerator
var generator

#Tilemap
@onready var tilemap = $TileMap
#Light
@onready var light = $PointLight2D
#Player
@onready var player = $Units/Player/Player
#EnemiesContainer
@onready var Enemies = $Units/Enemies

#Enemy
var enemy = preload("res://World/Units/Enemy/BasicEnemy/BasicEnemy.tscn")
#Torch
var torch = preload("res://World/Lighting/Torch.tscn")
#Item
var item = preload("res://Items/Item.tscn")

#worldspecific
var world_name
var amount_of_levels
var amount_of_rooms

#levelspecific
var stairPos

func _ready():
	GameLogic.set_world(self)
	GameLogic.game_active = true
	generator = get_node_or_null("/root/World/DungeonGenerator")
	

func _process(delta):
	var room = generator.get_room(player.position)
	if room == Rect2i(0,0,0,0):
		room = Rect2i(player.position.floor().x,player.position.floor().y,1*16,1*16)
	light.change_rect(Rect2(room))
		

#Most basic create_level function
func create_level():
	#ToDo set the level parameters here (roomcount etc.)
	generator.generate()
	await get_tree().create_timer(1.5).timeout
	position_player()

#Most basic position_player function
func position_player():
	var room_count = $DungeonGenerator/Rooms.get_child_count()
	var spawn_room = randi_range(0,room_count-1)
	var room = $DungeonGenerator/Rooms.get_children()[spawn_room]
	var room_position = room.position
	var room_extent = room.size
	player.set_pos((room_position/16).floor() * 16)
	
	
func spawn_enemy():
	var room_count = $DungeonGenerator/Rooms.get_child_count()
	var spawn_room = randi_range(0,room_count-1)
	var room = $DungeonGenerator/Rooms.get_children()[spawn_room]
	var room_position = room.position
	var room_extent = room.size
	var en = enemy.instantiate()
	Enemies.add_child(en)
	en.position = (room_position/16).floor() * 16

#Most basic position_stairs function
func position_stairs():
	var room_count = $DungeonGenerator/Rooms.get_child_count()
	var spawn_room = randi_range(0,room_count)
	var room = $DungeonGenerator/Rooms.get_children()[spawn_room]
	var room_position = room.position
	var room_extent = room.size
	stairPos = tilemap.local_to_map(room_position)
	
func spawn_lightsource():
	var room_count = $DungeonGenerator/Rooms.get_child_count()
	var spawn_room = randi_range(0,room_count-1)
	var room = $DungeonGenerator/Rooms.get_children()[spawn_room]
	var room_extent = room.get_extent()
	var tor = torch.instantiate()
	self.add_child(tor)
	tor.name = "Torch"
	tor.position = room_extent.position

func spawn_item():
	var room_count = $DungeonGenerator/Rooms.get_child_count()
	var spawn_room = randi_range(0,room_count-1)
	var room = $DungeonGenerator/Rooms.get_children()[spawn_room]
	var room_extent = room.get_extent()
	var it = item.instantiate()
	$Items.add_child(it)
	it.set_item(load("res://Items/Consumables/Apple.tres"))
	it.update()
	it.position = room_extent.position + Vector2i(32,32)
