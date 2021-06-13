extends KinematicBody2D

onready var animated_sprite = $AnimatedSprite

var wreckingBall = null
var velocity = Vector2.ZERO

# Player default stats
export var health = 6
export var max_health = 6
export var speed = 300
export var damage = 1

var attacking = false

signal set_max_health(value)
signal set_health(value)


# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite.play("idle")
	
	emit_signal("set_max_health", health)
	emit_signal("set_health", health)

func move():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("player_up"):
		velocity.y -= 1
	elif Input.is_action_pressed("player_down"):
		velocity.y += 1
	
	if Input.is_action_pressed("player_left"):
		velocity.x -= 1
	elif Input.is_action_pressed("player_right"):
		velocity.x += 1
	
	return velocity.normalized() * speed

func damage(var dmg):
	health -= dmg
	emit_signal("set_health", health)

func animate():
	if attacking:
		animated_sprite.play("attack")
		attacking == false
		return
	
	if velocity == Vector2.ZERO:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("moving")
		animated_sprite.flip_h = velocity.x <= 0

func _process(delta):
	#print(health)
	if health < 0:
		#print("DED")
		# TODO: Respawn
		pass
	
	var distance_to_ball = transform.origin.distance_to(wreckingBall.transform.origin)
	
	velocity = move()

	animate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_slide(velocity)
	wreckingBall.moveChain()
