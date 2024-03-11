class_name FireballSkill extends OneShotSkill

#Fireball Projectile
var fireball = preload("res://Skills/Fireball/Fireball.tscn")

func _init():
	super()
	name = "Fireball"
	icon = load("res://Skills/Fireball/Fireball.png")
	var path = "res://Skills/Fireball/Upgrades/"
	for i in range(1,6):
		var new_path = path + "Level" + str(i) + ".tres"
		var att:Attributes = load(new_path) as Attributes
		upgrades.append(att)

func use(callback:Callable):
	var fireball = Globals.fireball.instantiate()
	var dmg = get_attributes().get_damage()
	fireball.damage = dmg
	fireball.dir = owner.direction
	fireball.caster = owner
	owner.animations_running = true
	fireball.tree_exited.connect(callback)
	owner.add_child(fireball)
