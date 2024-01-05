extends Control

@onready var Skills = %Skills
@onready var Passives = %Passives
@onready var Items = %Items
@onready var Equipment = %Equipment
@onready var Log = %Log
@onready var Options = %Options
@onready var Exit = %Exit

#PauseWindow
@onready var pause = %PauseWindow
#Inventory
@onready var inventory = %InventoryWindow
#Equipment
@onready var equipments = %EquipmentMenu

var screen_pos:Vector2
var screen_size:Vector2
func _ready():
	screen_pos = self.position
	screen_size = self.size
	
	Skills.pressed.connect(on_skills)
	Passives.pressed.connect(on_passives)
	Items.pressed.connect(on_items)
	Equipment.pressed.connect(on_equipment)
	
func _process(delta):
	var focus_owner = get_viewport().gui_get_focus_owner()
	if visible and !inventory.visible and !equipments.visible and focus_owner == null:
		Skills.grab_focus()
	
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if inventory.visible:
			inventory.hide_inventory()
		elif equipments.visible:
			equipments.hide_equipment()
		else:
			if visible:
				hide_pausemenu()
				get_tree().paused = false
			else: 
				show_pausemenu()
				get_tree().paused = true
				Skills.grab_focus()
	elif event.is_action_pressed("ui_cancel"):
		if inventory.visible:
			inventory.hide_inventory()
		elif equipments.visible:
			equipments.hide_equipment()
		else:
			if visible:
				hide_pausemenu()
				get_tree().paused = false

func show_pausemenu():
	show()
	var anim_time = 0.1
	var tween = self.create_tween()
	tween.tween_property(pause,"position",screen_pos,anim_time).from(screen_pos - Vector2(pause.size.x,0))
	var tween2 = self.create_tween()
	tween2.tween_property(self,"custom_minimum_size",screen_size,anim_time).from(Vector2(0,screen_size.y))


func hide_pausemenu():
	var anim_time = 0.1
	var tween = self.create_tween()
	tween.tween_property(pause,"position",screen_pos - Vector2(pause.size.x,0),anim_time).from(screen_pos)
	var tween2 = self.create_tween()
	tween2.tween_property(self,"custom_minimum_size",Vector2(0,screen_size.y),anim_time).from(screen_size)
	tween2.tween_callback(hide)

func on_skills():
	pass
	
func on_passives():
	pass
	
func on_items():
	hide_everything()
	#await get_tree().create_timer(0.2).timeout
	inventory.show_inventory()
	
func on_equipment():
	hide_everything()
	equipments.show_equipment()
	
func on_log():
	pass
	
func on_options():
	pass
	
func on_exit():
	pass
	
func something_visible() -> bool:
	return inventory.visible or equipments.visible

func hide_everything():
	inventory.hide_inventory()
	equipments.hide_equipment()
	
