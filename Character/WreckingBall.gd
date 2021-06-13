extends KinematicBody2D

var character = null
var velocity = Vector2.ZERO

export var drag = 0.95
export var bounciness = 6
export var chain_distance = 70
export var chain_link_radius = 7
export var base_damage = 1

var distance_to_character = 0

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
	distance_to_character = transform.origin.distance_to(character.transform.origin)
	
	var chainDirection = (character.position - position).normalized()
	for i in range(chain_links.size()):
		chain_links[i].position = chainDirection * distance_to_character * (i + 1) / chain_links.size()

func _physics_process(delta):
	distance_to_character = transform.origin.distance_to(character.transform.origin)
	
	if distance_to_character > chain_distance:
		velocity = bounciness * (character.transform.origin - transform.origin)
	
	move_and_slide(velocity)
	moveChain()
	
	velocity *= drag
	
	for i in get_slide_count():
		if get_slide_collision(i).collider.has_method("damage"):
			print(base_damage * velocity.length())
			get_slide_collision(i).collider.damage(base_damage * velocity.length())
