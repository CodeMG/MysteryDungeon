extends Node

@onready var Start = $VBox/Start
@onready var Options = $VBox/Options
@onready var Credits = $VBox/Credits
@onready var Quit = $VBox/Quit

func _ready():
	Start.grab_focus()
	Start.pressed.connect(on_start)
	Options.pressed.connect(on_options)
	Credits.pressed.connect(on_credits)
	Quit.pressed.connect(on_quit)
	
func _unhandled_input(event):
	get_viewport().set_input_as_handled()
	
func on_start():
	#get_tree().change_scene_to_file("res://World/World.tscn")
	get_tree().change_scene_to_file("res://Overworld/Overworld.tscn")

func on_options():
	pass

func on_credits():
	pass

func on_quit():
	get_tree().quit()
