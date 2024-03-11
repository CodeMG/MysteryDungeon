extends Node

var background:Array[TextureRect]
var foreground:Array[TextureRect]

var left_point:Vector2 = Vector2(1100,340)
var right_point:Vector2 = Vector2(1550,340)

func _ready():
	for n in $Background.get_children():
		background.append(n)
	for n in $Foreground.get_children():
		foreground.append(n)

func _process(delta):
	for n in background:
		n.position.x -= delta*50*speed_ratio(n.position)
		if n.position.x <= left_point.x:
			background.erase(n)
			foreground.append(n)
			$Background.remove_child(n)
			$Foreground.add_child(n)
			$Foreground.move_child(n,0)
	for n in foreground:
		n.position.x += delta*50*speed_ratio(n.position)
		if n.position.x >= right_point.x:
			foreground.erase(n)
			background.append(n)
			$Foreground.remove_child(n)
			$Background.add_child(n)
			#$Background.move_child(n,0)

func speed_ratio(pos:Vector2):
	return sin((pos.x-200)*PI/(right_point.x-left_point.x)) /1.5 +0.1
