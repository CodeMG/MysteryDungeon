extends Camera2D

@onready var minimap = %Minimap

func adjust_to_tilemap():
	var minimap_rect = minimap.get_used_rect()
	var camera_rect = get_viewport_rect()
	minimap_rect.position *= Vector2i(16,16)
	minimap_rect.size *= Vector2i(16,16)
	offset = minimap_rect.position+Vector2i(minimap_rect.size*0.5)
	#var x_ratio = 1.0*minimap_rect.size.x/camera_rect.size.x
	#var y_ratio = 1.0*minimap_rect.size.y/camera_rect.size.y
	var x_ratio = 1.0*camera_rect.size.x/minimap_rect.size.x
	var y_ratio = 1.0*camera_rect.size.y/minimap_rect.size.y
	x_ratio -= 0.1
	y_ratio -= 0.1
	if x_ratio < y_ratio:
		zoom = Vector2(x_ratio,x_ratio)
	else:
		zoom = Vector2(y_ratio,y_ratio)
