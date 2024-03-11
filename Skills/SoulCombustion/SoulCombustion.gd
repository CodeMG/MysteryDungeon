class_name SoulCombustion extends Node2D

@onready var square:Sprite2D = $FireSquare

@onready var particle_horizontal1 = $HorizontalEdge
@onready var particle_horizontal2 = $HorizontalEdge2

@onready var particle_vertical1 = $VerticalEdge
@onready var particle_vertical2 = $VerticalEdge2

func _ready():
	set_size(Vector2(3,3))


func set_size(size:Vector2):
	square.texture.width = size.x*16
	square.texture.height = size.y*16
	
	square.material.set_shader_parameter("width",size.x*16)
	square.material.set_shader_parameter("height",size.y*16)
	
	particle_horizontal1.position.y = -size.y  *8 +4
	
	particle_horizontal1.emission_rect_extents = Vector2(8*size.x - 1,1)
	
	particle_horizontal2.position.y = size.y * 8 -4
	particle_horizontal2.emission_rect_extents = Vector2(8*size.x - 1,1)
	
	particle_vertical1.position.x = -size.x * 8 +4
	particle_vertical1.emission_rect_extents = Vector2(1,8*size.y - 1)
	
	particle_vertical2.position.x = size.x * 8 -4
	particle_vertical2.emission_rect_extents = Vector2(1,8*size.y - 1)
