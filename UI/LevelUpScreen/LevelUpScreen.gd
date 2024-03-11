extends Control

@onready var StatsContainer = $StatsContainer
@onready var StatsText = $StatsContainer/RichTextLabel
@onready var UpgradeContainer = $UpgradeContainer
@onready var skillButtons = $UpgradeContainer/HBoxContainer/SkillContainer/VBoxContainer
@onready var DescriptionText = $DescriptionContainer/RichTextLabel

var skill_button = preload("res://UI/LevelUpScreen/SkillButton.tscn")

#Stats change
var base_stats:Attributes
var changed_stats:Attributes

var counter = 0.0
var speed = 100
var max_time = 1.0

var skip:bool = false
func _ready():
	if Globals.player != null:
		Globals.player.leveled_up.connect(play_stats_anim)

func _process(delta):
	if Globals.player != null:
		if Globals.player.leveled_up.is_connected(play_stats_anim):
			if self.visible:
				update_stats_anim()
		else:
			Globals.player.leveled_up.connect(play_stats_anim)
	counter += delta
	if UpgradeContainer.visible:
		var focus_owner = get_viewport().gui_get_focus_owner()
		if focus_owner == null:
			skillButtons.get_child(0).grab_focus()

func _input(event):
	if visible and event.is_action_pressed("pause"):
		#counter = max_time
		skip = true
		get_viewport().set_input_as_handled()
		accept_event()

func reset():
	for b in skillButtons.get_children():
		b.queue_free()
	counter = 0.0
	base_stats = Globals.player.final_attributes
	changed_stats = Globals.player.level_up_attributes
	Globals.player.stats_changed.emit()

#UPGRADES

func hide_upgrades():
	hide()

func show_upgrades():
	UpgradeContainer.show()
	var skills= Globals.skills.duplicate()
	var upgrades = []
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in range(0,2):
		var index = rng.randi_range(0,1-i)
		var random_skill = skills[index]
		skills.remove_at(index)
		upgrades.append(random_skill)
	
	for sk in upgrades:
		var button = skill_button.instantiate()
		skillButtons.add_child(button)
		button.skill = sk
		button.update_look()
		button.update_description()
		button.pressed.connect(close_upgrades)

func close_upgrades():
	UpgradeContainer.hide()
	hide()

#STATS
func play_stats_anim(throwaway):
	show()
	StatsContainer.show()
	reset()
	get_tree().paused = true

func close_stats_anim():
	StatsContainer.hide()

func update_stats_anim():
	#wait for 1 sec
	StatsText.clear()
	var time = 1.0
	var tmp:bool = false
	
	for i in Attributes.base_stats:
		if skip:
			if counter < time:
				counter = time
				skip = false
			
		update_stat(counter,time,Attributes.get_name_by_att(i) + " ",base_stats.get_by_att(i),changed_stats.get_by_att(i))
		StatsText.append_text("\n")
		time = time + 1.0/speed * changed_stats.get_by_att(i) + 0.5
		
	
	max_time = time
	if counter > max_time + 0.5 and StatsContainer.visible:
		#get_tree().paused = false
		close_stats_anim()
		show_upgrades()
		

func update_stat(counter:float,start_time:float,name:String, base:float, delta:float) -> bool:
	var finished = false
	if counter > start_time:
		var progress = floor((counter-start_time)*speed)
		if progress > delta:
			finished = true
			progress = delta
		StatsText.append_text(name + str(base + progress) + " <- ")
		StatsText.push_color(Color.GREEN)
		StatsText.append_text(str(delta-progress))
		StatsText.pop()
	else:
		StatsText.append_text(name + str(base) + " <- ")
		StatsText.push_color(Color.GREEN)
		StatsText.append_text(str(delta))
		StatsText.pop()
	return finished
