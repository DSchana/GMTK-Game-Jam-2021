extends KinematicBody2D

var velocity = Vector2.ZERO
var player_speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("player_up"):
		velocity.y -= 1
	elif Input.is_action_pressed("player_down"):
		velocity.y += 1
	
	if Input.is_action_pressed("player_left"):
		velocity.x -= 1
	elif Input.is_action_pressed("player_right"):
		velocity.x += 1
	
	velocity = velocity.normalized() * player_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_slide(velocity)
	#$WreckingBall.move_and_slide(-velocity)
