class_name NPC

extends KinematicBody2D

onready var animated_sprite = $AnimatedSprite
onready var nav_2d : Navigation2D = $"../GameMap/Navigation2D"
onready var character : KinematicBody2D = $"../Character"
onready var collision_box : CollisionShape2D = $ColisionBox

var velocity = Vector2.ZERO
var path := PoolVector2Array()

const melee_range = 64

# NPC default stats
export var health = 100
export var speed = 50
export var melee = true
export var attack_range = 50
export var damage = 10

var attacking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite.play("idle")

func move():
	velocity = Vector2.ZERO
	
	if path.size() > 0:
		velocity = path[1] - global_position
	
	return velocity.normalized() * speed

func attack():
	if attacking:
		return
	
	if melee:
		for i in get_slide_count():
			if get_slide_collision(i).collider == character:
				attacking = true
				character.damage(damage)
	else:
		attacking = true
		# Ranged
		pass

func damage(var dmg):
	health -= dmg

func animate():
	if attacking:
		if animated_sprite.animation != "attack":
			animated_sprite.play("attack")
		return
	
	if velocity == Vector2.ZERO:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("moving")
		animated_sprite.flip_h = velocity.x >= 0

func _process(delta):
	if health <= 0:
		get_parent().remove_child(self)
	
	var distance_to_character = transform.origin.distance_to(character.transform.origin)
	
	path = nav_2d.get_simple_path(self.global_position, character.global_position)
	velocity = move()
	
	animate()
	
	if melee || (!melee && distance_to_character <= attack_range):
		attack()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_slide(velocity)


func _on_AnimatedSprite_animation_finished():
	if attacking:
		attacking = false
