extends PointLight2D

func change_rect(rect:Rect2):
	self.position = rect.position + rect.size*0.5 - Vector2(8,8)
	self.scale = rect.size/Vector2(16,16) + Vector2(2,2)
	
