extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.has_focus():
		self.modulate = Color(0.5,0.5,0.5)
	else:
		self.modulate = Color(1,1,1)
