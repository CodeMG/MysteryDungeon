extends Control

@onready var EquipmentGrid = %GridContainer

@onready var Helmet = %Helmet/Texture
@onready var Backpack = %Backpack/Texture
@onready var Weapon1 = %Weapon1/Texture
@onready var Bracelet = %Bracelet/Texture
@onready var BodyArmour = %BodyArmour/Texture
@onready var Amulet = %Amulet/Texture
@onready var Weapon2 = %Weapon2/Texture
@onready var Gloves = %Gloves/Texture
@onready var Boots = %Boots/Texture

@onready var inventory = %Inventory

var screen_pos:Vector2
var screen_width = 406
func _ready():
	GameLogic.game_started.connect(on_start)
	
	screen_pos = position
	
	
	%Helmet.pressed.connect(on_helmet)

func _process(delta):
	if !visible:
		return

	for i in EquipmentGrid.get_children():
		if i.has_focus():
			return
	if inventory.element_has_focus() != null:
		return
	Helmet.get_parent().grab_focus()

func show_equipment():
	if visible == true:
		return
	show()
	var anim_time = 0.1
	var tween = self.create_tween()
	var from = screen_pos + Vector2(screen_width,0)
	tween.tween_property(self,"position",screen_pos,anim_time).from(from)

func hide_equipment():
	if visible == false:
		return
	var anim_time = 0.1
	var tween = self.create_tween()
	tween.tween_property(self,"position",screen_pos + Vector2(screen_width,0),anim_time).from(screen_pos)
	tween.tween_callback(hide)




func on_start():
	if Globals.player != null:
		Globals.player.equipment_changed.connect(equipment_change)

func equipment_change(item):
	if item.source.type == Globals.EquipmentTypes.HELMET:
		set_Helmet(item.source.icon)
	elif item.source.type == Globals.EquipmentTypes.BACKPACK:
		set_Backpack(item.source.icon)
	elif item.source.type == Globals.EquipmentTypes.WEAPON1:
		set_Weapon1(item.source.icon)
	elif item.source.type == Globals.EquipmentTypes.WEAPON2:
		set_Weapon2(item.source.icon)
	elif item.source.type == Globals.EquipmentTypes.BRACELETS:
		set_Bracelet(item.source.icon)
	elif item.source.type == Globals.EquipmentTypes.AMULET:
		set_Amulet(item.source.icon)
	elif item.source.type == Globals.EquipmentTypes.BODY_ARMOUR:
		set_BodyArmour(item.source.icon)
	elif item.source.type == Globals.EquipmentTypes.GLOVES:
		set_Gloves(item.source.icon)
	elif item.source.type == Globals.EquipmentTypes.BOOTS:
		set_Boots(item.source.icon)

func set_Helmet(texture:Texture2D):
	Helmet.texture = texture

func set_Backpack(texture:Texture2D):
	Backpack.texture = texture
	
func set_Weapon1(texture:Texture2D):
	Weapon1.texture = texture
	
func set_Bracelet(texture:Texture2D):
	Bracelet.texture = texture
	
func set_BodyArmour(texture:Texture2D):
	BodyArmour.texture = texture
	
func set_Amulet(texture:Texture2D):
	Amulet.texture = texture
	
func set_Weapon2(texture:Texture2D):
	Weapon2.texture = texture
	
func set_Gloves(texture:Texture2D):
	Gloves.texture = texture
	
func set_Boots(texture:Texture2D):
	Boots.texture = texture

###############Equipment buttons######################

func on_helmet():
	var item = Globals.player.unequip_item(Globals.EquipmentTypes.HELMET)
	if item != null:
		Inventory.add_equipment_item(item)
	Helmet.texture = null

func on_backpack():
	var item = Globals.player.unequip_item(Globals.EquipmentTypes.BACKPACK)
	if item != null:
		Inventory.add_equipment_item(item)

