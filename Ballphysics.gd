extends RigidBody3D

func _ready():
	var direction = Vector3(1,0,0) * 50.0
	angular_velocity.z = direction.x
	angular_velocity.x = -direction.z
