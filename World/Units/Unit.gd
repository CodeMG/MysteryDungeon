class_name Unit extends Node2D

#Signals
signal died
signal spawned
signal received_damage
signal dealt_damage
signal leveled_up
signal stats_changed
signal equipment_changed
signal skills_changed
#The world the unit exists in
@onready var node_world = get_tree().current_scene

#Combat attributes
@export var attributes: Attributes
@export var final_attributes:Attributes #Attributes after Equipment and Buffs have been considered
@export var level_up_attributes:Attributes
var current_level = 1
var current_exp = 0
var max_exp = 100
var exp_granted = 100
var current_health
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
var action_time = 1
var time_counter: float
var time_to_action : float = 100
var animations_running: bool = false
var moving:bool = false
var direction : Vector2 = Vector2(1,0)

func _init():
	GameLogic.add_unit(self) #The Unit adds itself to the Gamelogics list of participating units
	stats_changed.connect(compute_final_attributes)
	compute_final_attributes()
	

#Perform action, if action was performed return true, else return false
func action() -> bool:
	return true

func process_effects():
	update_skills()

func update_skills():
	for skill in skills:
		if skill is DurationSkill:
			skill.update()

func move(target:Vector2i) -> bool:
	if moving:
		return false
	moving = true
	#animations_running = false
	move_anim(target)
	self.position = target
	return true

func move_anim(target:Vector2):
	var tween = self.create_tween()
	tween.tween_property($Look,"global_position",target,action_time).from(self.position)
	tween.tween_callback(animation_finished)
	tween.tween_callback(moving_finished)
	tween.tween_callback(reset_look)

func attack(target:Vector2):
	var current_pos = self.position
	var unit = node_world.unit_at_pos(target)
	if unit != null:
		var damage = create_damage()
		unit.receive_damage(damage)
	animations_running = true
	var tween = self.create_tween()
	tween.tween_property(self,"position",target,action_time/2).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self,"position",current_pos,action_time/2).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_callback(animation_finished)

func animation_finished():
	animations_running = false

func moving_finished():
	moving = false
 
func reset_look():
	$Look.position = Vector2(0,0)
	
func add_skill(skill:Skill):
	var has_skill = false
	var owned_skill = null
	for sk in skills:
		if sk.name == skill.name:
			has_skill = true
			owned_skill = sk
	if has_skill:
		owned_skill.level_up()
	else:
		skills.append(skill)
	skills_changed.emit()
	
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
	var total_damage = damage.fire_damage * (1.0-final_attributes.fire_resistance)
	total_damage += damage.earth_damage * (1.0-final_attributes.earth_resistance)
	total_damage += damage.water_damage * (1.0-final_attributes.water_resistance)
	total_damage += damage.lightning_damage * (1.0-final_attributes.lightning_resistance)
	total_damage += damage.physical_damage * (1.0)
	current_health -= total_damage
	if current_health <= 0:
		die()
	stats_changed.emit()

func heal(amount:int):
	current_health += amount
	if current_health > final_attributes.max_health:
		current_health = final_attributes.max_health
	stats_changed.emit()

func create_damage():
	var damage = final_attributes.get_damage()
	return damage

func level_up():
	current_level += 1
	attributes = attributes.combine_attributes(level_up_attributes)
	leveled_up.emit(current_level)

func receive_exp(exp):
	print("Received exp")
	current_exp += exp
	if current_exp >= max_exp:
		current_exp -= max_exp
		level_up()
		receive_exp(0)
		

func die():
	#Death anim
	animations_running = true
	var tween = get_tree().create_tween()
	self.modulate = Color(1.0,1.0,1.0,0.5)
	tween.tween_property(self,"modulate",Color(1.0,1.0,1.0,0.0),1.0).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_callback(emit_exp)
	tween.tween_callback(animation_finished)

func emit_exp():
	died.emit(exp_granted)
###### MISC #######

#Important because the owner variable of each skills gets resetted everytime a scene changes
func reset_skills():
	for sk in skills:
		sk.owner = self
