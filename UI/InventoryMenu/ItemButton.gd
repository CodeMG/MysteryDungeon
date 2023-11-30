class_name ItemButton extends HBoxContainer

@onready var textureRect:TextureRect = $TextureRect
@onready var button:Button = $Button

var item:Item

func _ready():
	button.pressed.connect(on_pressed)

func on_pressed():
	item.use()
	Inventory.erase_item(item)

func update():
	set_icon(item.icon)
	set_text(item.name)

func set_icon(icon:Texture2D):
	textureRect.texture = icon

func set_text(text:String):
	button.text = text
