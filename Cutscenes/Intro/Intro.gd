extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var environment_anims = %EnvironmentAnimations
@onready var broken_lamp = %Broken_Lamp
@onready var lampy = %Lampy
@onready var player_anim = %Player
@onready var lightningSound:AudioStreamPlayer = %Lightning

@export var dialogue:DialogueResource
var counter = 0
func _ready():
	animation_player.play("MerchantWalkin")
	#DialogueManager.dialogue_ended.connect(cont)
	DialogueManager.dialogue_ended.connect(cont)
	player_anim.play("Walking_(1 0)")
	lampy.get_node("AnimationPlayer").play("Lampy_idle")
	#counter = 14
	
func _process(delta):
	if !animation_player.is_playing() and counter == 0:
		DialogueManager.show_dialogue_balloon(dialogue,"part_1")
		cont()
	elif counter == 1:
		animation_player.play("MerchantWalkin2")
		cont()
	elif counter == 3 and !animation_player.is_playing():
		player_anim.play("default")
		DialogueManager.show_dialogue_balloon(dialogue,"part_2")
		cont()
	elif counter == 5:
		animation_player.play("MoveForward")
		cont()
	elif counter == 6 and !animation_player.is_playing():
		broken_lamp.visible = false
		animation_player.play("MoveBackward")
		cont()
	elif counter == 7 and !animation_player.is_playing():
		DialogueManager.show_dialogue_balloon(dialogue,"part_3")
		cont()
	elif counter == 9 and !animation_player.is_playing():
		lampy.visible = true
		DialogueManager.show_dialogue_balloon(dialogue,"part_4")
		cont()
	elif counter == 11:
		animation_player.play("Lampy_walking_right")
		cont()
	elif counter == 12 and !animation_player.is_playing():
		DialogueManager.show_dialogue_balloon(dialogue,"part_5")
		cont()
	elif counter == 14:
		animation_player.play("Walking_together")
		DialogueManager.show_dialogue_balloon(dialogue,"part_6")
		cont()
	elif counter == 16:
		DialogueManager.show_dialogue_balloon(dialogue,"lightning")
		lightningSound.play(2.1)
		
		environment_anims.play("Lightning")
		cont()
	elif counter == 18:
		DialogueManager.show_dialogue_balloon(dialogue,"part_7")
		cont()
	elif (counter == 19 or counter == 20) and !animation_player.is_playing():
		animation_player.play("Walking_loop")
		counter = 21
		
	if lightningSound.get_playback_position() >= 7.0:
		lightningSound.stop()

func cont(resource = ""):
	counter += 1

