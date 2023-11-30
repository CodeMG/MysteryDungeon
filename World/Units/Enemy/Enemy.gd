class_name Enemy extends Unit

#Notifier for checking if the units is on the screen
@onready var notifier = $VisibleOnScreenNotifier2D

var in_light:bool = false
#AI
enum AI_STATES{
	IDLE,
	AGGRESSIVE
}
var current_state:AI_STATES
var current_targetLocation: Vector2i
var current_path= []



func _init():
	super()
	current_state = AI_STATES.IDLE
	
func _ready():
	action_time = 0.1
	

func action()->bool:
	var tmp = action_time
	#Check if the Enemy can be seen
	if !notifier.is_on_screen() || !in_light:
		action_time = 0.0001
	AI()
	action_time = tmp
	return true

func AI():
	if current_state == AI_STATES.IDLE:
		if current_path.size() == 0:
			#Find new random target location
			var c = Globals.CELL_SIZE
			var room:Rect2i = node_world.get_random_room()
			var x = randi_range(0,(room.size.x/c)-1)*c
			var y = randi_range(0,(room.size.y/c)-1)*c
			current_targetLocation = Vector2i(room.position.x + x,room.position.y + y)
			current_path = node_world.get_path_on_grid(Vector2i(position.floor()),current_targetLocation)
			current_path.reverse() #More efficient, because we remove the next target every step
			current_path.remove_at(current_path.size()-1)# To remove the start which is where the AI already is at
		else:
			#Check if enemy can see player:
			var room = node_world.get_room(Vector2i(position))
			var player_room = node_world.get_room(Vector2i(node_world.node_player.position))
			if room != Rect2i(0,0,0,0) && player_room != Rect2i(0,0,0,0):
				if room == player_room:
					current_state = AI_STATES.AGGRESSIVE
			else:
				for i in range(-1,2):
					for j in range(-1,2):
						var p_pos = Vector2i(node_world.node_player.position)
						var test_pos = Vector2i(position.x+i*Globals.CELL_SIZE,position.y+j*Globals.CELL_SIZE)
						if p_pos == test_pos:
							current_state = AI_STATES.AGGRESSIVE
							return
			#Go to target location
			var targetPos = current_path[current_path.size()-1]
			direction = Vector2i(targetPos.floor())-Vector2i(position.floor())
			direction = Vector2i(sign(direction.x),sign(direction.y))
			if !node_world.enemy_at_pos(targetPos):
				move(targetPos)
				current_path.remove_at(current_path.size()-1)
			else:
				current_path.clear()
			
	elif current_state == AI_STATES.AGGRESSIVE:
		#If the enemy is next to the player:
		var dist = (node_world.node_player.position - position).length()
		print(dist)
		if dist < 2*16:
			attack(node_world.node_player.position)
		else:# Else calculate path to player and move
			current_path.clear()
			var playerPos = node_world.node_player.position
			current_path = node_world.get_path_on_grid(Vector2i(position.floor()),playerPos)
			var targetPos = current_path[1]
			direction = Vector2i(targetPos.floor())-Vector2i(position.floor())
			direction = Vector2i(sign(direction.x),sign(direction.y))
			if !node_world.enemy_at_pos(targetPos):
				move(targetPos)

func animation_finished():
	super.animation_finished()

#func _draw():
#	var tmp = current_path.duplicate()
#	tmp.reverse()
#	for i in range(1,tmp.size()):
#		draw_line(tmp[i-1]-position,tmp[i]-position,Color(1,0,0),1)
#	draw_line(Vector2.ZERO,direction*8,Color(0,0,1),1)
#	#top_level = true
#	#draw_multiline(current_path,Color(1,0,0))

func set_in_light(v:bool):
	in_light = v 
	
func die():
	super.die()
	queue_free()
