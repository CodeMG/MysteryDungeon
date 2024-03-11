class_name Skill

#Icon
var icon:Texture2D
#Owner
var owner: Unit
#Skill properties
var name:String
var mana_cost:float
var stamina_cost:float
var level:int
var upgrades:Array[Attributes]

func _init():
	level = 0

func use(callback:Callable):
	pass

func get_attributes():
	return upgrades[level-1]

func level_up():
	level = level + 1
