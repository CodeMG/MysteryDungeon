class_name ItemButton extends HBoxContainer

@onready var textureRect:TextureRect = $TextureRect
@onready var button:Button = $Button

var item:Item

func _ready():
	button.pressed.connect(on_pressed)

func on_pressed():
	if item is EquippableItem:
		var check = Globals.player.equip_item(item)
		if check:
			Inventory.erase_equipment_item(item)
		update()
	elif item is ConsumableItem:
		item.source.use()
		Inventory.erase_item(item)
	

func focus():
	button.grab_focus()

func update():
	set_icon(item.source.icon)  
	set_text(item.source.name)

func set_icon(icon:Texture2D):
	textureRect.texture = icon

func set_text(text:String):
	button.text = text
