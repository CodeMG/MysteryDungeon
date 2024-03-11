extends Node

signal game_started
signal action_performed

#The States that the game can be in
enum States{
	INIT,
	LOAD,
	UNIT_TURN,
	END_CHECK,
	END
}
var current_state : States
var current_unit
var world #The current world being played
var units = [] #A container for the current units that follow the round based movement
var game_active: bool = false #A bool to check if the game has started (for Menus and stuff)

var turn = 0

func _ready():
	current_state = States.INIT
	Globals.scene_change.connect(reset) #If we change the scene then we reset the game loop
	
func _process(delta):
	#Check if a Unit has been freed
	var tmp = []
	for u in units:
		if is_instance_valid(u):
			tmp.append(u)
	units.clear()
	units.append_array(tmp)
	
	#State machine
	if current_state == States.INIT:
		#Initialize Game
		
		#staircase_activated.connect
		if game_active:
			current_state = States.LOAD
		else:
			current_state = States.INIT
	if current_state == States.LOAD:
		#Load things and make sure everything is ready
		world.create_level()
		game_started.emit()
		current_state = States.UNIT_TURN
		turn= 0
	if current_state == States.UNIT_TURN:
		#Check whoose turn it is, and allow them to act
		if units.size() == 0: return
		current_unit = get_current_unit()
		var performed = current_unit.action()
		if performed:
			current_unit.time_counter -= current_unit.time_to_action
			current_state = States.END_CHECK
			
		else:
			pass
	if current_state == States.END_CHECK:
		#Check for end turn things (over time effects, animations, etc.)
		#First check if all units have their animations finished:
		for unit in units:
			if unit.animations_running:
				return
		#Then check for end of turn effects for current unit
		current_unit.process_effects() #If the unit has performed an action then process their effects
		#Optional: Check for end of turn effects of everyone
		current_state = States.UNIT_TURN
		turn += 1
		action_performed.emit()
	if current_state == States.END:
		#End game
		pass
		
func add_unit(unit : Unit):
	units.append(unit)
	
#Check which units turn it is going to be
func get_current_unit() -> Unit:
	var array = get_actionable_units()
	#Get the actionable unit that had the highest counter (Should act first)
	if array.size() != 0:
		var soonest_unit = array[0]
		for unit in array:
			if unit.time_counter > soonest_unit.time_counter:
				soonest_unit = unit
		return soonest_unit
	else:
		for unit in units:
			unit.time_counter += unit.attributes.speed
		return get_current_unit() #recursive call until a unit can act
func get_actionable_units() -> Array:
	var array = []
	for unit in units:
		if unit.time_counter > unit.time_to_action:
			array.append(unit)
	return array


func start_new_level():
	#Check if the end is reached
	if world.current_level == world.world_resource.max_levels:
			get_tree().change_scene_to_file("res://Overworld/Overworld.tscn")
	current_state = States.INIT

func set_world(w):
	world = w

func reset():
	current_state = States.INIT
