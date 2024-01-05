extends PanelContainer

@onready var items = %Inventory/%Items
@onready var DescriptionHead = %DescriptionHead
@onready var DescriptionBody = %DescriptionBody
var current_item_button:ItemButton

func _process(delta):
	var current_focused_button
	for item in items.get_children():
		if item.button.has_focus():
			current_focused_button = item
			
	if current_item_button != current_focused_button && current_focused_button != null:
		show_item(current_focused_button)
		current_item_button = current_focused_button
	elif current_focused_button == null:
		current_item_button = null
		hide()

func show_item(new_item_button):
	show()
	var item = new_item_button.item
	if item is ConsumableItem:
		show_consumable(item)
	elif item is EquippableItem:
		show_equippable(item)
		
func show_consumable(item: ConsumableItem):
	pass
	
func show_equippable(item:EquippableItem):
	DescriptionHead.text = "[center]" + str(item.source.name) +"[/center]"
	var body_text = str(item.source.attributes.armor) + " Armor \n" 
	
	if item.offensive_modifier1 != null:
		body_text += str(item.offensive_modifier1.get_description()) + "\n"
	if item.offensive_modifier2 != null:
		body_text += str(item.offensive_modifier2.get_description()) + "\n"
	if item.defensive_modifier1 != null:
		body_text += str(item.defensive_modifier1.get_description()) + "\n"
	if item.defensive_modifier2 != null:
		body_text += str(item.defensive_modifier2.get_description()) + "\n"
	DescriptionBody.text = body_text
