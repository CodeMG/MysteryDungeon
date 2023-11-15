class_name HealingItem extends ConsumableItem

@export var life:int

func use():
	owner.heal(life)
