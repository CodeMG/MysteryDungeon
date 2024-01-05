class_name Attributes extends Resource

enum ATT{
	MAX_HEALTH = 0,
	STAMINA = 1,
	MANA = 2,
	#Offense
	PHYSICAL_DAMAGE = 3,
	ETHEREAL_DAMAGE = 4,
	FIRE_DAMAGE = 5,
	WATER_DAMAGE = 6,
	EARTH_DAMAGE = 7,
	LIGHTNING_DAMAGE = 8,
	INCREASED_PHYSICAL_DAMAGE = 9,
	INCREASED_ETHEREAL_DAMAGE = 10,
	INCREASED_FIRE_DAMAGE = 11,
	INCREASED_WATER_DAMAGE = 12,
	INCREASED_EARTH_DAMAGE = 13,
	INCREASED_LIGHTNING_DAMAGE = 14,
	MORE_PHYSICAL_DAMAGE = 15,
	MORE_ETHEREAL_DAMAGE = 16,
	MORE_FIRE_DAMAGE = 17,
	MORE_WATER_DAMAGE = 18,
	MORE_EARTH_DAMAGE = 19,
	MORE_LIGHTNING_DAMAGE = 20,
	#Defense
	ARMOR = 21,
	EVASION = 22,
	SOUL_SHIELD = 23,
	INCREASED_ARMOR = 24,
	INCREASED_EVASION = 25,
	INCREASED_SOUL_SHIELD = 26,
	MORE_ARMOR = 27,
	MORE_EVASION = 28,
	MORE_SOUL_SHIELD = 29,
	#MISC
	SPEED = 30,
}

#Combat
#Base Stats
@export var current_health = 0.0
@export var max_health = 0.0
@export var stamina = 0.0
@export var mana = 0.0

#Offensive
@export var physical_damage = 0.0
@export var ethereal_damage = 0.0

@export var fire_damage = 0.0
@export var water_damage = 0.0
@export var earth_damage = 0.0
@export var lightning_damage = 0.0

#Defensive
@export var armor = 0.0
@export var evasion = 0.0
@export var soul_shield = 0.0

@export var water_resistance = 0.0
@export var fire_resistance = 0.0
@export var earth_resistance = 0.0
@export var lightning_resistance = 0.0

#Additive
#Offensive
@export var increase_physical_damage = 1.0
@export var increase_ethereal_damage = 1.0

@export var increase_water_damage = 1.0
@export var increase_fire_damage = 1.0
@export var increase_earth_damage = 1.0
@export var increase_lightning_damage = 1.0

#Defensive

@export var increase_armor = 1.0
@export var increase_evasion = 1.0
@export var increase_soul_shield = 1.0

#Multiplicative
#Offensive
@export var more_physical_damage = 1.0
@export var more_ethereal_damage = 1.0

@export var more_water_damage = 1.0
@export var more_fire_damage = 1.0
@export var more_earth_damage = 1.0
@export var more_lightning_damage = 1.0

#Defensive

@export var more_armor = 1.0
@export var more_evasion = 1.0
@export var more_soul_shield = 1.0

#GameLogic
@export var speed = 0.0


################################Methods#############################

#Method for getting a specific attribute by enum name (Necessary because no way to get reference any other way)
func get_by_att(att:ATT):
	if att == ATT.MAX_HEALTH:
		return max_health
	elif att == ATT.STAMINA:
		return stamina
	elif att == ATT.MANA:
		return mana
	elif att == ATT.PHYSICAL_DAMAGE:
		return physical_damage
	elif att == ATT.ETHEREAL_DAMAGE:
		return ethereal_damage
	elif att == ATT.FIRE_DAMAGE:
		return fire_damage
	elif att == ATT.WATER_DAMAGE:
		return water_damage
	elif att == ATT.EARTH_DAMAGE:
		return earth_damage
	elif att == ATT.LIGHTNING_DAMAGE:
		return lightning_damage
	elif att == ATT.INCREASED_PHYSICAL_DAMAGE:
		return increase_physical_damage
	elif att == ATT.INCREASED_ETHEREAL_DAMAGE:
		return increase_ethereal_damage
	elif att == ATT.INCREASED_FIRE_DAMAGE:
		return increase_fire_damage
	elif att == ATT.INCREASED_WATER_DAMAGE:
		return increase_water_damage
	elif att == ATT.INCREASED_EARTH_DAMAGE:
		return increase_earth_damage
	elif att == ATT.INCREASED_LIGHTNING_DAMAGE:
		return increase_lightning_damage
	elif att == ATT.MORE_PHYSICAL_DAMAGE:
		return more_physical_damage
	elif att == ATT.MORE_ETHEREAL_DAMAGE:
		return more_ethereal_damage
	elif att == ATT.MORE_FIRE_DAMAGE:
		return more_fire_damage
	elif att == ATT.MORE_WATER_DAMAGE:
		return more_water_damage
	elif att == ATT.MORE_EARTH_DAMAGE:
		return more_earth_damage
	elif att == ATT.MORE_LIGHTNING_DAMAGE:
		return more_lightning_damage
	elif att == ATT.ARMOR:
		return armor
	elif att == ATT.EVASION:
		return evasion
	elif att == ATT.SOUL_SHIELD:
		return soul_shield
	elif att == ATT.INCREASED_ARMOR:
		return increase_armor
	elif att == ATT.INCREASED_EVASION:
		return increase_evasion
	elif att == ATT.INCREASED_SOUL_SHIELD:
		return increase_soul_shield
	elif att == ATT.MORE_ARMOR:
		return more_armor
	elif att == ATT.MORE_EVASION:
		return more_evasion
	elif att == ATT.MORE_SOUL_SHIELD:
		return more_soul_shield
	elif att == ATT.SPEED:
		return speed

func set_by_att(att:ATT,new_value):
	if att == ATT.MAX_HEALTH:
		max_health = new_value
	elif att == ATT.STAMINA:
		stamina = new_value
	elif att == ATT.MANA:
		mana = new_value
	elif att == ATT.PHYSICAL_DAMAGE:
		physical_damage = new_value
	elif att == ATT.ETHEREAL_DAMAGE:
		ethereal_damage = new_value
	elif att == ATT.FIRE_DAMAGE:
		fire_damage = new_value
	elif att == ATT.WATER_DAMAGE:
		water_damage = new_value
	elif att == ATT.EARTH_DAMAGE:
		earth_damage = new_value
	elif att == ATT.LIGHTNING_DAMAGE:
		lightning_damage = new_value
	elif att == ATT.INCREASED_PHYSICAL_DAMAGE:
		increase_physical_damage = new_value
	elif att == ATT.INCREASED_ETHEREAL_DAMAGE:
		increase_ethereal_damage = new_value
	elif att == ATT.INCREASED_FIRE_DAMAGE:
		increase_fire_damage = new_value
	elif att == ATT.INCREASED_WATER_DAMAGE:
		increase_water_damage = new_value
	elif att == ATT.INCREASED_EARTH_DAMAGE:
		increase_earth_damage = new_value
	elif att == ATT.INCREASED_LIGHTNING_DAMAGE:
		increase_lightning_damage = new_value
	elif att == ATT.MORE_PHYSICAL_DAMAGE:
		more_physical_damage = new_value
	elif att == ATT.MORE_ETHEREAL_DAMAGE:
		more_ethereal_damage = new_value
	elif att == ATT.MORE_FIRE_DAMAGE:
		more_fire_damage = new_value
	elif att == ATT.MORE_WATER_DAMAGE:
		more_water_damage = new_value
	elif att == ATT.MORE_EARTH_DAMAGE:
		more_earth_damage = new_value
	elif att == ATT.MORE_LIGHTNING_DAMAGE:
		more_lightning_damage = new_value
	elif att == ATT.ARMOR:
		armor = new_value
	elif att == ATT.EVASION:
		evasion = new_value
	elif att == ATT.SOUL_SHIELD:
		soul_shield = new_value
	elif att == ATT.INCREASED_ARMOR:
		increase_armor = new_value
	elif att == ATT.INCREASED_EVASION:
		increase_evasion = new_value
	elif att == ATT.INCREASED_SOUL_SHIELD:
		increase_soul_shield = new_value
	elif att == ATT.MORE_ARMOR:
		more_armor = new_value
	elif att == ATT.MORE_EVASION:
		more_evasion = new_value
	elif att == ATT.MORE_SOUL_SHIELD:
		more_soul_shield = new_value
	elif att == ATT.SPEED:
		speed = new_value

func combine_attributes(att:Attributes) -> Attributes:
	var out:Attributes = Attributes.new()
	
	out.current_health = att.current_health + current_health
	out.max_health = att.max_health + max_health
	out.stamina = att.stamina + stamina
	out.mana = att.mana + mana
	
	out.physical_damage = att.physical_damage + physical_damage
	out.ethereal_damage = att.ethereal_damage + ethereal_damage
	
	out.fire_damage = att.fire_damage + fire_damage
	out.water_damage = att.water_damage + water_damage
	out.earth_damage = att.earth_damage + earth_damage
	out.lightning_damage = att.lightning_damage + lightning_damage
	
	out.increase_physical_damage = att.increase_physical_damage + increase_physical_damage
	out.increase_ethereal_damage = att.increase_ethereal_damage + increase_ethereal_damage
	
	out.increase_fire_damage = att.increase_fire_damage + increase_fire_damage
	out.increase_water_damage = att.increase_water_damage + increase_water_damage
	out.increase_earth_damage = att.increase_earth_damage + increase_earth_damage
	out.increase_lightning_damage = att.increase_lightning_damage + increase_lightning_damage
	
	out.more_physical_damage = att.more_physical_damage * more_physical_damage
	out.more_ethereal_damage = att.more_ethereal_damage * more_ethereal_damage
	
	out.more_fire_damage = att.more_fire_damage * more_fire_damage
	out.more_water_damage = att.more_water_damage * more_water_damage
	out.more_earth_damage = att.more_earth_damage * more_earth_damage
	out.more_lightning_damage = att.more_lightning_damage * more_lightning_damage
	
	out.speed = att.speed + speed
	
	return out
