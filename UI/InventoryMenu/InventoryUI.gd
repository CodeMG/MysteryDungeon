extends PanelContainer

@onready var itemList:ItemList = $ItemList

func _ready():
	Inventory.item_inventory_changed.connect(update_ItemList)

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		var arr = itemList.get_selected_items()
		if arr.size() != 0:
			Inventory.itemInventory[arr[0]].use()
			Inventory.remove_item(arr[0])
		
func update_ItemList():
	itemList.clear()
	for item in Inventory.itemInventory:
		itemList.add_item(item.name,item.icon,true)
