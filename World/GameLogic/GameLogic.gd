extends Node

enum States{
	INIT,
	LOAD,
	UNIT_TURN,
	END_CHECK,
	END
}

var world

var units = []

var current_state : States

var game_active: bool = false

func _ready():
	current_state = States.INIT
	
func _process(delta):
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
		current_state = States.UNIT_TURN
	if current_state == States.UNIT_TURN:
		#Check whoose turn it is, and allow them to act
		if units.size() == 0: return
		var current_unit = get_current_unit()
		var action_performed = current_unit.action()
		if action_performed:
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
		
		current_state = States.UNIT_TURN
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
	current_state = States.INIT

func set_world(w):
	world = w
