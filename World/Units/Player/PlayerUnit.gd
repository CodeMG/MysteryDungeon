class_name PlayerUnit extends Unit

signal moved

@onready var healthLabel:Label = $CanvasLayer/Control/HBoxContainer/Label
@onready var healthBar:TextureProgressBar = $CanvasLayer/Control/HBoxContainer/TextureProgressBar

func _init():
	super()

func _ready():
	super._ready()
	moved.emit()
	attributes.current_health *= 0.5
	update_health_UI()
	
	
func _process(delta):
	update_health_UI()
	
func action()->bool:
	if get_tree().paused:
		return false
	#Running
	action_time = 0.1
	if Input.is_action_pressed("run"):
		action_time = 0.01
	#Walking
	var targetPos = self.position
	if Input.is_action_pressed("move_right"):
		targetPos = self.position + Vector2(16,0)
		direction = Vector2(1,0)
	elif Input.is_action_pressed("move_left"):
		targetPos = self.position - Vector2(16,0)
		direction = Vector2(-1,0)
	elif Input.is_action_pressed("move_up"):
		targetPos = self.position - Vector2(0,16)
		direction = Vector2(0,-1)
	elif Input.is_action_pressed("move_down"):
		targetPos = self.position + Vector2(0,16)
		direction = Vector2(0,1)
	if wall_at_pos(Vector2i(targetPos)) || enemy_at_pos(Vector2i(targetPos)) || npc_at_pos(Vector2i(targetPos)):
			return false
	if targetPos != self.position:
		animations_running = true
		var tween = self.create_tween()
		tween.tween_property(self,"position",targetPos,action_time)
		tween.tween_callback(animation_finished)
		return true
	#Attack
	if Input.is_action_pressed("attack"):
		var currentPos = self.position
		targetPos = self.position + Vector2(16,16)*direction
		var enemy = enemy_at_pos(Vector2i(targetPos))
		var npc = npc_at_pos(Vector2i(targetPos))
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
	healthLabel.text = str(attributes.current_health) + "/" + str(attributes.max_health)
	healthBar.min_value = 0
	healthBar.max_value = attributes.max_health
	healthBar.value = attributes.current_health

func set_pos(pos: Vector2):
	position = pos
	moved.emit()

func dialogue_finished(dialogueResource):
	await get_tree().create_timer(0.1).timeout
	super.animation_finished()

func animation_finished():
	moved.emit()
	super.animation_finished()
