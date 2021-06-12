extends KinematicBody2D

var character = null
var velocity = Vector2.ZERO

var drag = 0.95
var bounciness = 6
var chain_distance = 50

func onCharacterMove():
	if transform.origin.distance_to(character.transform.origin) > chain_distance:
		velocity = transform.origin.distance_to(character.transform.origin)

func _physics_process(delta):
	
	if transform.origin.distance_to(character.transform.origin) > chain_distance:
		velocity = bounciness * (character.transform.origin - transform.origin)
	
	move_and_slide(velocity)
	velocity *= drag
