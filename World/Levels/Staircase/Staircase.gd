class_name Staircase extends Area2D

@onready var popup = $"Control/ConfirmationDialog"

func _init():
	area_entered.connect(on_collision)
	
func _ready():
	popup.confirmed.connect(next_level)
	popup.canceled.connect(cancel)
	
func on_collision(area: Area2D):
	if area.name == "Player":
		popup.visible = true
		get_tree().paused = true
	
func next_level():
	get_tree().paused = false
	GameLogic.start_new_level()
	
	

func cancel():
	get_tree().paused = false
