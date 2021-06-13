extends Node2D

func _ready():
	$WreckingBall.character = $Character
	$Character.wreckingBall = $WreckingBall
	
	$CanvasLayer/GUIControl.connect("set_skin", $Character, "setSkin")
	$CanvasLayer/GUIControl.connect("game_start", self, "setUpLabyrinth")
	$Character.connect("set_health", $CanvasLayer/GUIControl, "setGameHealth")

func setUpLabyrinth():
	$Character.updateHealth()
