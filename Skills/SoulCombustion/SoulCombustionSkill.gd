class_name SoulCombustionSkill extends DurationSkill

var soulCombustionEffect = preload("res://Skills/SoulCombustion/SoulCombustion.tscn")
var active:bool = false

func _init():
	super()
	name = "Soul Combustion"
	icon = load("res://Skills/SoulCombustion/SoulCombustion_icon.png")
	var path = "res://Skills/SoulCombustion/Upgrades/"
	for i in range(1,6):
		var new_path = path + "Level" + str(i) + ".tres"
		var att:Attributes = load(new_path) as Attributes
		upgrades.append(att)

func use(callback:Callable):
	if !active:
		var sc = soulCombustionEffect.instantiate()
		sc.name = "SC"
		owner.get_node("Look").add_child(sc)
		active = true
	else:
		active = false
		var sc = owner.get_node("Look").get_node("SC")
		sc.queue_free()
	callback.call()
	
#Gets called once a turn
func update():
	if !active:
		return
	var rect = Rect2i(Vector2i(owner.position.x-16,owner.position.y-16),Vector2i(3,3))
	var units = GameLogic.world.units_in_rect(rect)
	for u in units:
		var d = get_attributes().get_damage()
		u.receive_damage(d)

