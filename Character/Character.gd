extends KinematicBody2D

onready var animated_sprite = $DefaultSkin

var wreckingBall = null
var velocity = Vector2.ZERO

# Player default stats
export var health = 6
export var max_health = 6
export var speed = 300
export var damage = 1

var attacking = false

signal set_health(current, total)
signal on_death

func setSkin(skin):
	if skin == "normal":
		animated_sprite.visible = false
		animated_sprite = $DefaultSkin
		animated_sprite.visible = true
	if skin == "golden":
		animated_sprite.visible = false
		animated_sprite = $GoldenSkin
		animated_sprite.visible = true

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite.play("idle")
	

func setHealth(h, m_h):
	health = h
	max_health = m_h
	emit_signal("set_health", health, max_health)

func updateHealth():
	emit_signal("set_health", health, max_health)

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
	emit_signal("set_health", health, max_health)

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
	if health <= 0:
		emit_signal("on_death")
	
	var distance_to_ball = transform.origin.distance_to(wreckingBall.transform.origin)
	
	velocity = move()

	animate()
	
	for i in get_slide_count():
		if get_slide_collision(i).collider is PowerUp:
			var type = get_slide_collision(i).collider.type
			
			if type == "health_pack":
				if health < max_health:
					health += 1
					emit_signal("set_health", health, max_health)
			
			get_parent().remove_child(get_slide_collision(i).collider)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_slide(velocity)
	wreckingBall.moveChain()
