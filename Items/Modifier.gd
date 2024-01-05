class_name Modifier extends Resource

@export var description:String
@export var type:Attributes.ATT
@export var amount:float

func get_description():
	return description % amount
