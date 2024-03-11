class_name PlayerUnit extends Unit

signal moved

#UI
@onready var healthLabel:Label = %Label
@onready var healthBar:TextureProgressBar = %TextureProgressBar
@onready var levelNumber:Label = %LevelNumber

#Skills
@onready var skill1_texture:TextureRect = $HUD/HBoxContainer/Control/BottomBar/GridContainer/PanelContainer/TextureRect
@onready var skill2_texture:TextureRect = $HUD/HBoxContainer/Control/BottomBar/GridContainer/PanelContainer2/TextureRect
@onready var skill3_texture:TextureRect = $HUD/HBoxContainer/Control/BottomBar/GridContainer/PanelContainer3/TextureRect
@onready var skill4_texture:TextureRect = $HUD/HBoxContainer/Control/BottomBar/GridContainer/PanelContainer4/TextureRect

#Animation
@onready var corner_anim:AnimatedSprite2D = $Look/Corner_Anim
@onready var idle_anim:AnimatedSprite2D = $Look/Idle_Anim

var base_action_speed = 0.2
var running_action_speed = 0.05


func _init():
	super()

func _ready():
	Globals.player = self
	moved.emit()
	compute_final_attributes()
	current_health = final_attributes.max_health
	update_health_UI()
	leveled_up.connect(update_ui_level)
	skills_changed.connect(update_ui_skills)
	#var fb = FireballSkill.new()
	#fb.level = 1
	#fb.owner = self
	#skills.append(fb)
	#var sc = SoulCombustionSkill.new()
	#sc.level = 1
	#sc.owner = self
	#skills.append(sc)
	reset_skills()
	
func _process(delta):
	update_health_UI()
	switch_idle_anim(direction)
	
func action()->bool:
	# If the game is paused
	if get_tree().paused:
		return false

	var input = process_input()
	return input

func process_input() -> bool:
	#If the player wants to pass his turn
	if Input.is_action_pressed("Pass"):
		return true
	#Running
	action_time = base_action_speed
	if Input.is_action_pressed("run"):
		action_time = running_action_speed
		
	#Walking
	var targetPos = self.position
	if Input.is_action_pressed("move_right"):
		targetPos = targetPos + Vector2(Globals.CELL_SIZE,0)
	elif Input.is_action_pressed("move_left"):
		targetPos = targetPos - Vector2(Globals.CELL_SIZE,0)
	if Input.is_action_pressed("move_up"):
		targetPos = targetPos - Vector2(0,Globals.CELL_SIZE)
	elif Input.is_action_pressed("move_down"):
		targetPos = targetPos + Vector2(0,Globals.CELL_SIZE)
	
	#Get the direction of movement
	var d = targetPos - self.position
	#"Normalize" the direction
	if d.length() > 0:
		direction = Vector2(sign(d.x),sign(d.y))
	
	#If we only allow diagonal movement
	if Input.is_action_pressed("move_diagonal"):
		corner_anim.visible = true
		if (targetPos-self.position).length() <= 16.1: # If the player is trying to move non-diagonally
			targetPos = self.position
	else:
		corner_anim.visible = false

	# If there is a movement set, and the input is not "show grid", we move
	if targetPos != self.position and not Input.is_action_pressed("show_grid"):
		if node_world.wall_at_pos(Vector2i(targetPos)) || node_world.enemy_at_pos(Vector2i(targetPos)) || node_world.npc_at_pos(Vector2i(targetPos)):
			return false
		return move(targetPos)
	if Input.is_action_just_pressed("use_skill_1") && skills.size() > 0 && skills[0] != null:
		skills[0].use(animation_finished)
		return true
	elif Input.is_action_just_pressed("use_skill_2")&& skills.size() > 1 &&  skills[1] != null:
		skills[1].use(animation_finished)
	#Attack
	if Input.is_action_pressed("attack"):
		var currentPos = self.position
		targetPos = self.position + Vector2(16,16)*direction
		var enemy = node_world.enemy_at_pos(Vector2i(targetPos))
		var npc = node_world.npc_at_pos(Vector2i(targetPos))
		if enemy != null:
			var damage = final_attributes.get_damage()
			enemy.receive_damage(damage)
		if npc != null:
			npc.activate(dialogue_finished)
			animations_running = true
		if npc == null:
			animations_running = true
			var tween = self.create_tween()
			tween.tween_property(self,"position",targetPos,action_time/2).set_trans(Tween.TRANS_EXPO)
			tween.tween_property(self,"position",currentPos,action_time/2).set_trans(Tween.TRANS_EXPO)
			tween.tween_callback(animation_finished)
		return true
		
	return false

func receive_damage(damage: DamageInfo):
	super.receive_damage(damage)
	update_health_UI()

func update_health_UI():
	#Update Healthbar
	healthLabel.text = str(current_health) + "/" + str(final_attributes.max_health)
	healthBar.min_value = 0
	healthBar.max_value = final_attributes.max_health
	healthBar.value = current_health

func set_pos(pos: Vector2):
	position = pos
	moved.emit()

func dialogue_finished(dialogueResource):
	await get_tree().create_timer(0.1).timeout
	super.animation_finished()

func animation_finished():
	moved.emit()
	super.animation_finished()

func update_ui_level(level:int):
	levelNumber.text = str(level)

func update_ui_skills():
	if skills.size() > 0 and skills[0] != null:
			skill1_texture.texture = skills[0].icon
	if skills.size() > 1 and skills[1] != null:
			skill2_texture.texture = skills[1].icon
	if skills.size() > 2 and skills[2] != null:
			skill3_texture.texture = skills[2].icon
	if skills.size() > 3 and skills[3] != null:
			skill4_texture.texture = skills[3].icon

func switch_idle_anim(dir:Vector2):
	var name = "Wizard_Idle_("
	if dir.x >= 0:
		idle_anim.flip_h = false
		name += str(dir.x) + " " + str(dir.y) + ")"
	else:
		idle_anim.flip_h = true
		name += str(dir.x*-1) + " " + str(dir.y) + ")"
	
	idle_anim.animation = name 

func die():
	pass
