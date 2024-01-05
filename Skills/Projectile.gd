extends Area2D

var damage:DamageInfo
var caster:Unit
var dir:Vector2
func _ready():
	self.body_entered.connect(on_tilemap_collision)
	self.area_entered.connect(on_unit_collision)
	
func _process(delta):
	if dir == null:
		return
	look_at(global_position + dir*10)
	position += 500*delta*dir

func on_tilemap_collision(body:Node2D):
	queue_free()

func on_unit_collision(body:Unit):
	var unit = body
	if unit == caster:
		return
	unit.receive_damage(damage)
	queue_free()
