class_name Staircase extends Area2D

@onready var popup = $"Control/ConfirmationDialog"

func _init():
	area_entered.connect(on_collision)
	
func _ready():
	popup.confirmed.connect(next_level)
	
func on_collision(area: Area2D):
	if area.name == "Player":
		popup.visible = true
	
func next_level():
	GameLogic.start_new_level()
