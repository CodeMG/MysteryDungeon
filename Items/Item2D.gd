class_name Item2D extends Area2D

var item: Item

@onready var sprite:Sprite2D = $Sprite2D

func _init():
	area_entered.connect(on_collision)
	

func set_item(i:Item):
	item = i

func update():
	sprite.texture = item.icon
	self.name = item.name

func on_collision(area):
	print("Test")
	if area.name == "Player":
		item.owner = area as Unit
		Inventory.add_item(item)
		queue_free()
	
