extends Node2D

var character = get_parent()

signal set_max_health(value)
signal set_heath(value)

func _ready():
	hide()
	if get_parent() and get_parent().get("max_health"):
		emit_signal("set_max_health", get_parent().max_health)
		emit_signal("set_health", get_parent().max_health)

func update_healthbar(value):
	emit_signal("set_health", value)
