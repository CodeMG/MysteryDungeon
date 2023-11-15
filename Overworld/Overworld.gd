extends World

var bob_scene = preload("res://World/Units/NPCs/Bob.tscn")
var bob
func _ready():
	super._ready()
	place_player()
	place_npcs()
	
func _process(delta):
	pass
	
func create_level():
	place_player()
	place_npcs()

func place_player():
	player.set_pos((Vector2(78,111) / 16).floor() * 16)

func place_npcs():
	var bob = bob_scene.instantiate()
	$Units/NPCs.add_child(bob)
	bob.position = (Vector2(-130,-100) / 16).floor() * 16
	
