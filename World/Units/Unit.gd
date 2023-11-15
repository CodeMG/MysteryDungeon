extends Node2D

class_name Unit

#Scene nodes
var tilemap
var Enemies
#Combat attributes
@export var attributes: UnitAttributes
var action_time = 0.1
#GameLogic
var time_counter: float
var time_to_action : float = 100
var animations_running: bool = false
var direction : Vector2 = Vector2(1,0)

func _init():
	GameLogic.add_unit(self)
	attributes = UnitAttributes.new()
	
func _ready():
	tilemap = get_node("/root/World/TileMap")
	Enemies = get_node("/root/World/Units/Enemies")

func wall_at_pos(pos:Vector2i) -> bool:
	return !tilemap.get_cell_tile_data(1,tilemap.local_to_map(pos-Vector2i(16,16))) == null

func npc_at_pos(pos:Vector2i) -> Area2D:
	for npc in  $"../../NPCs".get_children():
		if Vector2i(npc.position.floor()) == pos:
			return npc
	return null

func enemy_at_pos(targetPos: Vector2i) -> Area2D:
	for enemy in Enemies.get_children():
		if Vector2i(enemy.position.floor()) == targetPos:
			print("Enemy there")
			return enemy
		pass
	return null

#Perform action, if action was performed return true, else return false
func action() -> bool:
	return true
	
func animation_finished():
	animations_running = false
	
func receive_damage(damage: DamageInfo):
	attributes.current_health -= damage.physical_damage
	if attributes.current_health <= 0:
		visible = false
		
		
#Atribute functions
func heal(amount:int):
	attributes.current_health += amount
	if attributes.current_health > attributes.max_health:
		attributes.current_health = attributes.max_health
	
