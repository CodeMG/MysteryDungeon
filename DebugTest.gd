extends Node2D

@onready var ray:RayCast2D = $RayCast2D
@onready var label:Label = $Label
@onready var pivot:Node2D = $Pivot
@onready var dot:Node2D = $Pivot/Dot

# Called when the node enters the scene tree for the first time.
func _ready():
	var dir = dot.global_position - pivot.global_position
	print("normalized dir: " + str(dir.normalized()))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if velocity.length() > 0.1:
		ray.target_position = velocity.normalized() * 50
	label.text = "Ray length: " + str(ray.target_position.length())
