extends Node2D

func _ready():
	$WreckingBall.character = $Character
	$Character.wreckingBall = $WreckingBall
