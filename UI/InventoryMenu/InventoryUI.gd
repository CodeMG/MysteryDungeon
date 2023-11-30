extends PanelContainer

@onready var items = $Items
var itemButton = preload("res://UI/InventoryMenu/item_button.tscn")
func _ready():
	Inventory.item_inventory_changed.connect(update_ItemList)

func _process(delta):
	pass
		
func update_ItemList():
	for i in items.get_children():
		i.queue_free()
	for item in Inventory.itemInventory:
		create_itemButton(item)

func create_itemButton(item:Item):
	var ib:ItemButton = itemButton.instantiate()
	items.add_child(ib)
	ib.item = item
	ib.update()

