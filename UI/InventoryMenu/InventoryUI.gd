extends Control

@export var itemInventory: bool = true #If true then the UI will load the item inventory and not the equipment inventory

@onready var items = %Items
var itemButton = preload("res://UI/InventoryMenu/item_button.tscn")

var screen_pos:Vector2

func _ready():
	screen_pos = Vector2(1580,0)
	
	if itemInventory:
		Inventory.item_inventory_changed.connect(update_ItemList)
	else:
		Inventory.equipment_inventory_changed.connect(update_ItemList)

func _process(delta):
	if !itemInventory or (items.get_children().size() == 0 or !is_visible_in_tree()):
		return
	var owner_of_focus = element_has_focus()
	if owner_of_focus == null:
		items.get_child(0).focus()
func update_ItemList():
	for i in items.get_children():
		i.queue_free()
	if itemInventory:
		for item in Inventory.itemInventory:
			create_itemButton(item)
	else:
		for item in Inventory.equipmentInventory:
			create_itemButton(item)

func create_itemButton(item:Item):
	var ib:ItemButton = itemButton.instantiate()
	items.add_child(ib)
	ib.item = item
	ib.update()

func show_inventory():
	if visible == true:
		return
	
	show()
	var anim_time = 0.1
	var tween = self.create_tween()
	tween.tween_property(self,"position",screen_pos,anim_time).from(screen_pos + Vector2(self.size.x,0))

func hide_inventory():
	if visible == false:
		return
	var anim_time = 0.1
	var tween = self.create_tween()
	tween.tween_property(self,"position",screen_pos + Vector2(self.size.x,0),anim_time).from(screen_pos)
	tween.tween_callback(hide)

func element_has_focus() -> Control:
	var one_has_focus:Control
	for i in items.get_children():
		if i.button.has_focus():
			one_has_focus = i
			break
	return one_has_focus
