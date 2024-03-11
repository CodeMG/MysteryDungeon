extends Button


var skill:Skill
var description:String
func _ready():
	pressed.connect(on_press)

func update_look():
	icon = skill.icon

func update_description():
	description = skill.name

func on_press():
	Globals.player.add_skill(skill)
	skill.owner = Globals.player
	get_tree().paused = false
