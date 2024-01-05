class_name Item2D extends Area2D

var item: Item

@onready var sprite:Sprite2D = $Sprite2D

func _init():
	area_entered.connect(on_collision)
	

func set_item(i:Item):
	item = i
	update()

func update():
	sprite.texture = item.source.icon
	self.name = item.source.name

func on_collision(area):
	if area.name == "Player":
		item.owner = area as Unit
		if item is EquippableItem:
			Inventory.add_equipment_item(item)
		elif item is ConsumableItem:
			Inventory.add_item(item)
		queue_free()
	
