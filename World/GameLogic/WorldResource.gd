class_name WorldResource extends Resource

@export var name:String
@export var max_levels:int
@export var min_rooms:int
@export var max_rooms:int

@export var terraintSet:int
@export var terrain:int

@export var item_weight_padding:int
@export var spawnable_items:Array[ItemResource]
@export var enemy_weight_padding:int
@export var spawnable_enemies:Array[EnemyResource]
