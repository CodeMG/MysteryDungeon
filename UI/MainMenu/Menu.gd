extends Node

@onready var Main = %Main
@onready var Start = %Main/VBox/Start
@onready var Options = %Main/VBox/Options
@onready var Credits = %Main/VBox/Credits
@onready var Quit = %Main/VBox/Quit

@onready var Save_Select = %SaveSelect

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
	#get_tree().change_scene_to_file("res://Overworld/Overworld.tscn")
	Main.visible = false
	Save_Select.visible = true

func on_options():
	pass

func on_credits():
	pass

func on_quit():
	get_tree().quit()
