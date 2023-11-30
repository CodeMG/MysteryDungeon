class_name Unit extends Node2D

#Signals
signal died
signal spawned
signal received_damage
signal dealt_damage
signal leveled_up
#The world the unit exists in
@onready var node_world = get_tree().current_scene

#Combat attributes
@export var attributes: UnitAttributes
var current_level = 1
var current_exp = 0
var max_exp = 100
var exp_granted = 200

#GameLogic
var action_time = 0.1
var time_counter: float
var time_to_action : float = 100
var animations_running: bool = false
var direction : Vector2 = Vector2(1,0)

func _init():
	GameLogic.add_unit(self) #The Unit adds itself to the Gamelogics list of participating units
	attributes = UnitAttributes.new() #Create/Load Attributes

#Perform action, if action was performed return true, else return false
func action() -> bool:
	return true
	
func move(target:Vector2):
	animations_running = true
	var tween = self.create_tween()
	tween.tween_property(self,"position",target,action_time)
	tween.tween_callback(animation_finished)

func attack(target:Vector2):
	var current_pos = self.position
	var unit = node_world.unit_at_pos(target)
	if unit != null:
		var damage = create_damage()
		unit.receive_damage(damage)
	animations_running = true
	var tween = self.create_tween()
	tween.tween_property(self,"position",target,action_time/2)
	tween.tween_property(self,"position",current_pos,action_time/2)
	tween.tween_callback(animation_finished)

func animation_finished():
	animations_running = false
	
#Atribute functions
func receive_damage(damage: DamageInfo):
	attributes.current_health -= damage.physical_damage
	if attributes.current_health <= 0:
		die()

func heal(amount:int):
	attributes.current_health += amount
	if attributes.current_health > attributes.max_health:
		attributes.current_health = attributes.max_health

func create_damage():
	var damage = DamageInfo.new()
	damage.physical_damage = 10
	return damage

func level_up():
	current_level += 1
	attributes.max_health += 10
	attributes.current_health += 10
	attributes.damage += 10
	leveled_up.emit(current_level)

func receive_exp(exp):
	print("Received exp")
	current_exp += exp
	if current_exp >= max_exp:
		current_exp -= max_exp
		level_up()
		receive_exp(0)
	

func die():
	died.emit(exp_granted)
