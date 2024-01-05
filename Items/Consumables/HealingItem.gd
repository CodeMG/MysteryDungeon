class_name HealingItemResource extends ConsumableItemResource

@export var life:int

func use():
	Globals.player.heal(life)
