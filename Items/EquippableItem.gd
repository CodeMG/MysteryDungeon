class_name EquippableItem extends Item

var offensive_modifier1:Modifier
var offensive_modifier2:Modifier
var defensive_modifier1:Modifier
var defensive_modifier2:Modifier

#Applys stats to attributes
func update_stats(att:Attributes) -> Attributes:
	var new_att = Attributes.new()
	if offensive_modifier1 != null:
		new_att.set_by_att(offensive_modifier1.type,offensive_modifier1.amount)
	if offensive_modifier2 != null:
		new_att.set_by_att(offensive_modifier2.type,offensive_modifier2.amount)
	
	if defensive_modifier1 != null:
		new_att.set_by_att(defensive_modifier1.type,defensive_modifier1.amount)
	if defensive_modifier2 != null:
		new_att.set_by_att(defensive_modifier2.type,defensive_modifier2.amount)
	return att.combine_attributes(new_att.combine_attributes(source.attributes))

func generate_mods():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var amount_of_mods = rng.randi_range(0,4)
	if amount_of_mods > 0:
		var mod = Globals.modlist[rng.randi_range(0,Globals.modlist.size()-1)]
		offensive_modifier1 = mod
	if amount_of_mods > 1:
		var mod = Globals.modlist[rng.randi_range(0,Globals.modlist.size()-1)]
		offensive_modifier2 = mod
	if amount_of_mods > 2:
		var mod = Globals.modlist[rng.randi_range(0,Globals.modlist.size()-1)]
		defensive_modifier1 = mod
	if amount_of_mods > 3:
		var mod = Globals.modlist[rng.randi_range(0,Globals.modlist.size()-1)]
		defensive_modifier2 = mod
	
