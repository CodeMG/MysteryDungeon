extends Node

signal item_inventory_changed
signal equipment_inventory_changed

#Item Inventory
var itemInventory = []
var inventorySize = 20

#Equipment Inventory
var equipmentInventory = []
var equipmentInventorySize = 20

func add_item(item:Item) -> bool:
	if itemInventory.size() < inventorySize:
		itemInventory.append(item)
		item_inventory_changed.emit()
		return true
	return false

func remove_item(index:int) -> bool:
	itemInventory.remove_at(index)
	item_inventory_changed.emit()
	return true

func add_equipment_item(item) -> bool:
	if equipmentInventory.size() < equipmentInventorySize:
		equipmentInventory.append(item)
		equipment_inventory_changed.emit()
		return true
	return false

func erase_equipment_item(item) -> bool:
	equipmentInventory.erase(item)
	equipment_inventory_changed.emit()
	return true

func erase_item(item) -> bool:
	itemInventory.erase(item)
	item_inventory_changed.emit()
	return true
