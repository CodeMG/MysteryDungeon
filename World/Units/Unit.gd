class_name Unit extends Node2D

#Signals
signal died
signal spawned
signal received_damage
signal dealt_damage
signal leveled_up
signal stats_changed
signal equipment_changed
#The world the unit exists in
@onready var node_world = get_tree().current_scene

#Combat attributes
@export var attributes: Attributes
@export var final_attributes:Attributes #Attributes after Equipment and Buffs have been considered
var current_level = 1
var current_exp = 0
var max_exp = 100
var exp_granted = 200

#Skills
var skills:Array[Skill]

#Equipment
var helmet:EquippableItem
var backpack:EquippableItem
var weapon1:EquippableItem
var bracelet:EquippableItem
var body_armour:EquippableItem
var amulet:EquippableItem
var weapon2:EquippableItem
var gloves:EquippableItem
var boots:EquippableItem

#GameLogic
var action_time = 0.1
var time_counter: float
var time_to_action : float = 100
var animations_running: bool = false
var direction : Vector2 = Vector2(1,0)

func _init():
	GameLogic.add_unit(self) #The Unit adds itself to the Gamelogics list of participating units
	attributes = Attributes.new() #Create/Load Attributes
	attributes.current_health = 10
	attributes.max_health = 10
	attributes.speed = 10
	stats_changed.connect(compute_final_attributes)
	

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
	
	
#Inventory Functions
func unequip_item(type:Globals.EquipmentTypes) -> EquippableItem:
	var item = null
	if type == Globals.EquipmentTypes.HELMET:
		item = helmet
		helmet = null
	elif type == Globals.EquipmentTypes.BACKPACK:
		item = backpack
		backpack = null
	elif type == Globals.EquipmentTypes.WEAPON1:
		item = weapon1
		weapon1 = null
	elif type == Globals.EquipmentTypes.WEAPON2:
		item = weapon2
		weapon2 = null
	elif type == Globals.EquipmentTypes.BRACELETS:
		item = bracelet
		bracelet = null
	elif type == Globals.EquipmentTypes.AMULET:
		item = amulet
		amulet = null
	elif type == Globals.EquipmentTypes.BODY_ARMOUR:
		item = body_armour
		body_armour = null
	elif type == Globals.EquipmentTypes.GLOVES:
		item = gloves
		gloves = null
	elif type == Globals.EquipmentTypes.BOOTS:
		item = boots
		boots = null
	equipment_changed.emit(item)
	stats_changed.emit()
	return item

func equip_item(item:EquippableItem) -> bool:
	var success = false
	if item.source.type == Globals.EquipmentTypes.HELMET:
		if helmet != null:
			return false
		helmet = item
		success = true
	elif item.source.type == Globals.EquipmentTypes.BACKPACK:
		if backpack != null:
			return false
		backpack = item
		success = true
	elif item.source.type == Globals.EquipmentTypes.WEAPON1:
		if weapon1 != null:
			return false
		weapon1 = item
		success = true
	elif item.source.type == Globals.EquipmentTypes.WEAPON2:
		if weapon2 != null:
			return false
		weapon2 = item
		success = true
	elif item.source.type == Globals.EquipmentTypes.BRACELETS:
		if bracelet != null:
			return false
		bracelet = item
		success = true
	elif item.source.type == Globals.EquipmentTypes.AMULET:
		if amulet != null:
			return false
		amulet = item
		success = true
	elif item.source.type == Globals.EquipmentTypes.BODY_ARMOUR:
		if body_armour != null:
			return false
		body_armour = item
		success = true
	elif item.source.type == Globals.EquipmentTypes.GLOVES:
		if gloves != null:
			return false
		gloves = item
		success = true
	elif item.source.type == Globals.EquipmentTypes.BOOTS:
		if boots != null:
			return false
		boots = item
		success = true

	if success:
		equipment_changed.emit(item)
		stats_changed.emit()
		
	return success
	
func is_equipped(item:EquippableItem) -> bool:
	if helmet == item:
		return true
	if backpack == item:
		return true
	if weapon1 == item:
		return true
	if weapon2 == item:
		return true
	if bracelet == item:
		return true
	if amulet == item:
		return true
	if body_armour == item:
		return true
	if gloves == item:
		return true
	if boots == item:
		return true
	return false
#Atribute functions

func compute_final_attributes():
	final_attributes = attributes
	if helmet != null:
		final_attributes = helmet.update_stats(final_attributes)


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
