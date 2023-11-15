class_name NPC extends RigidBody2D

@export var dialogue: DialogueResource

func activate(callback:Callable):
	DialogueManager.show_example_dialogue_balloon(dialogue,"Start")
	DialogueManager.dialogue_ended.connect(callback,CONNECT_ONE_SHOT)

 
