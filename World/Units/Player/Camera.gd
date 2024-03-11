extends Node2D

@onready var player = $"../Units/Player/Player"
var target
var start
# Called when the node enters the scene tree for the first time.
func _ready():
	target = Vector2(0,0)
	start = Vector2(0,0)
	player.moved.connect(update_camera)
	update_camera()


func update_camera():
	target = player.position
	start = position
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movement:Vector2 = target - position
	var change = movement*delta*5
	position += change
