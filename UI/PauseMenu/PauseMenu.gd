extends Control

@onready var Skills = $HBoxContainer/VBoxContainer/Skills
@onready var Passives = $HBoxContainer/VBoxContainer/Passives
@onready var Items = $HBoxContainer/VBoxContainer/Items
@onready var SpecialActions = $HBoxContainer/VBoxContainer/SpecialActions
@onready var Log = $HBoxContainer/VBoxContainer/Log
@onready var Options = $HBoxContainer/VBoxContainer/Options
@onready var Exit = $HBoxContainer/VBoxContainer/Exit

#Inventory
@onready var inventory = $HBoxContainer/Inventory

func _ready():
	
	Skills.pressed.connect(on_skills)
	Passives.pressed.connect(on_passives)
	Items.pressed.connect(on_items)
	
func _process(delta):
	if visible:
		get_tree().paused = true
	else:
		get_tree().paused = false
	if Input.is_action_just_pressed("pause"):
		if inventory.visible:
			inventory.hide()
		else:
			if visible:hide()
			else: 
				show()
				Skills.grab_focus()
	if Input.is_action_just_pressed("ui_cancel"):
		if inventory.visible:
			inventory.hide()
		else:
			if visible:hide()
	
func on_skills():
	pass
	
func on_passives():
	pass
	
func on_items():
	inventory.show()
	
func on_special():
	pass
	
func on_log():
	pass
	
func on_options():
	pass
	
func on_exit():
	pass
