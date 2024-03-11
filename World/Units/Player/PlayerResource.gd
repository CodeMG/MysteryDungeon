class_name PlayerResource extends Resource

enum PlayerClass {
	WIZARD,
	WARRIOR,
	MERCHANT,
}

@export var name:String
@export var look:PlayerClass
