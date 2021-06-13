extends KinematicBody2D

var character = null
var velocity = Vector2.ZERO

export var drag = 0.95
export var bounciness = 6
export var chain_distance = 70
export var chain_link_radius = 7

var chain_links = []
onready var chain_link = preload("res://Character/ChainLink.tscn")

func _ready():
	for i in range(chain_distance / chain_link_radius * 0.5):
		chain_links.append(chain_link.instance())
		add_child(chain_links[i])

func onCharacterMove():
	if transform.origin.distance_to(character.transform.origin) > chain_distance:
		velocity = transform.origin.distance_to(character.transform.origin)

func moveChain():
	var chainDirection = (character.position - position).normalized()
	var distance_to_character = transform.origin.distance_to(character.transform.origin)
	for i in range(chain_links.size()):
		chain_links[i].position = chainDirection * distance_to_character * (i + 1) / chain_links.size()

func _physics_process(delta):
	if transform.origin.distance_to(character.transform.origin) > chain_distance:
		velocity = bounciness * (character.transform.origin - transform.origin)
	
	move_and_slide(velocity)
	moveChain()
	
	velocity *= drag
	
	# TODO: Damage enemies
