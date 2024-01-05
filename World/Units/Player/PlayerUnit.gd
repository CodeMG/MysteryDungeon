class_name PlayerUnit extends Unit

signal moved

#UI
@onready var healthLabel:Label = %Label
@onready var healthBar:TextureProgressBar = %TextureProgressBar
@onready var levelNumber:Label = %LevelNumber

#Animation
@onready var corner_anim:AnimatedSprite2D = $Corner_Anim
@onready var idle_anim:AnimatedSprite2D = $Idle_Anim

func _init():
	super()

func _ready():
	Globals.player = self
	moved.emit()
	attributes.max_health = 1000
	attributes.current_health = 500
	compute_final_attributes()
	update_health_UI()
	leveled_up.connect(update_ui_level) 
	skills.append(FireballSkill.new().init(self))
	
func _process(delta):
	update_health_UI()
	switch_idle_anim(direction)
	
func action()->bool:
	# If the game is paused
	if get_tree().paused:
		return false
		
	#If the player wants to pass his turn
	if Input.is_action_pressed("Pass"):
		return true

	#Running
	action_time = 0.1
	if Input.is_action_pressed("run"):
		action_time = 0.01
		
	#Walking
	var targetPos = self.position
	if Input.is_action_pressed("move_right"):
		targetPos = targetPos + Vector2(16,0)
	elif Input.is_action_pressed("move_left"):
		targetPos = targetPos - Vector2(16,0)
	if Input.is_action_pressed("move_up"):
		targetPos = targetPos - Vector2(0,16)
	elif Input.is_action_pressed("move_down"):
		targetPos = targetPos + Vector2(0,16)
	
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
		move(targetPos)
		return true
	if Input.is_action_just_pressed("use_skill_1"):
		skills[0].use(animation_finished)
		return true
	#Attack
	if Input.is_action_pressed("attack"):
		var currentPos = self.position
		targetPos = self.position + Vector2(16,16)*direction
		var enemy = node_world.enemy_at_pos(Vector2i(targetPos))
		var npc = node_world.npc_at_pos(Vector2i(targetPos))
		if enemy != null:
			var damage = DamageInfo.new()
			damage.physical_damage = 10
			enemy.receive_damage(damage)
		if npc != null:
			npc.activate(dialogue_finished)
			animations_running = true
		if npc == null:
			animations_running = true
			var tween = self.create_tween()
			tween.tween_property(self,"position",targetPos,action_time/2)
			tween.tween_property(self,"position",currentPos,action_time/2)
			tween.tween_callback(animation_finished)
		return true
	return false
	
	
func receive_damage(damage: DamageInfo):
	super.receive_damage(damage)
	update_health_UI()

func update_health_UI():
	#Update Healthbar
	healthLabel.text = str(final_attributes.current_health) + "/" + str(final_attributes.max_health)
	healthBar.min_value = 0
	healthBar.max_value = final_attributes.max_health
	healthBar.value = final_attributes.current_health

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

func switch_idle_anim(dir:Vector2):
	var name = "Wizard_Idle_("
	if dir.x >= 0:
		idle_anim.flip_h = false
		name += str(dir.x) + " " + str(dir.y) + ")"
	else:
		idle_anim.flip_h = true
		name += str(dir.x*-1) + " " + str(dir.y) + ")"
	
	idle_anim.animation = name 
