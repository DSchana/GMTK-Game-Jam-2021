extends Node2D

# Unique rooms
onready var startRoom = preload("res://Rooms/StartRoom.tscn")

# Random rooms
onready var powerUpRoom = preload("res://Rooms/PowerUpRoom.tscn")
onready var horizontalHallway = preload("res://Rooms/HorizontalHallway.tscn")
onready var verticalHallway = preload("res://Rooms/VerticalHallway.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(startRoom.instance())


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
