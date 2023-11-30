extends CanvasLayer

@onready var label:Label = $Control/ColorRect/Label

func set_text(text:String):
	label.text = text
