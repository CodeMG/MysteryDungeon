extends Node2D

var scene = preload("res://bullet.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	var b:RigidBody2D = scene.instantiate()
	self.add_child(b)
	b.position = self.position
	b.gravity_scale = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
