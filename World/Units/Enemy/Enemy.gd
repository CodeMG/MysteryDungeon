class_name Enemy extends Unit

@onready var notifier = $VisibleOnScreenNotifier2D

func _init():
	super()
func _ready():
	action_time = 0.01
	super._ready()
func action()->bool:
	var targetPos = self.position + Vector2(16,0)
	if wall_at_pos(Vector2i(targetPos)):
		return true
	var tmp = action_time
	if notifier.is_on_screen():
		print("True")
		action_time = 0.000001
	animations_running = true
	var tween = self.create_tween()
	tween.tween_property(self,"position",targetPos,action_time)
	tween.tween_callback(animation_finished)
	action_time = tmp
	#Set view direction
	direction = Vector2(1,0)
	return true


