extends Control

@onready var save1:MenuButton = %Save1
@onready var save2:MenuButton = %Save2
@onready var save3:MenuButton = %Save3

@onready var Main = get_parent().get_node("Main")

func _ready():
	reset_popups()
	reset_text()
	
	save1.get_popup().id_pressed.connect(on_save1)
	save2.get_popup().id_pressed.connect(on_save2)
	save3.get_popup().id_pressed.connect(on_save3)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		self.visible = false
		Main.visible = true

func _process(delta):
	var width = save1.get_rect().size.x
	save1.get_popup().set_position(save1.position + Vector2(width,0.0))

func reset_text():
	var date = Globals.get_date_of_progress(1)
	if date == null:
		save1.get_child(0).text = "Empty File"
	else:
		save1.get_child(0).text = Globals.get_date_of_progress(1)

func reset_popups():
	save1.get_popup().clear()
	save2.get_popup().clear()
	save3.get_popup().clear()
	
	var empty = !Globals.progress_exists(1)
	if empty:
		save1.get_popup().add_item("Start new Game",0)
	else:
		save1.get_popup().add_item("Start",0)
		save1.get_popup().add_item("Delete",1)

func on_save1(id:int):
	var empty = !Globals.progress_exists(1)
	if id == 0:
		if empty:
			#Start new game
			Globals.save_progress(1)
			var tween = self.get_tree().create_tween()
			tween.tween_property(%Camera2D,"position",Vector2(960,1281),3).set_ease(Tween.EASE_IN_OUT)
			tween.tween_callback(Globals.start_intro)
			#Globals.start_intro()
			self.visible = false
		else:
			#Load game
			pass
	elif id == 1:
		#Delete game
		Globals.delete_progress(1)
		pass
	reset_popups()
	reset_text()

func on_save2(id:int):
	pass
	

func on_save3(id:int):
	pass
