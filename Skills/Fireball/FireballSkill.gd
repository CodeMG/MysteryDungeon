class_name FireballSkill extends Skill

#Fireball Projectile
var fireball = preload("res://Skills/Fireball/Fireball.tscn")

func use(callback:Callable):
	var fireball = Globals.fireball.instantiate()
	var dmg = DamageInfo.new()
	dmg.physical_damage = 100
	fireball.damage = dmg
	fireball.dir = owner.direction
	fireball.caster = owner
	owner.animations_running = true
	fireball.tree_exited.connect(callback)
	owner.add_child(fireball)
