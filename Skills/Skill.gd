class_name Skill

#Icon
var icon:Texture2D

#Owner
var owner: Unit

#Skill properties
var mana_cost:float
var stamina_cost:float

func init(owner:Unit,mana_cost:float = 0,stamina_cost:float = 0) -> Skill:
	self.owner = owner
	self.mana_cost = mana_cost
	self.stamina_cost = stamina_cost
	return self

func use(callback:Callable):
	pass
