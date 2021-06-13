extends KinematicBody2D

onready var animated_sprite = $AnimatedSprite
onready var nav_2d : Navigation2D = $"../GameMap/Navigation2D"
onready var character : KinematicBody2D = $"../Character"

var velocity = Vector2.ZERO
var path := PoolVector2Array()

# NPC default stats
export var health = 100
export var speed = 50
export var attack_range = 5  # 5 is melee
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
	attacking = true
	if attack_range <= 5:
		character.damage(damage)
		pass
	else:
		# Ranged
		pass

func animate():
	if attacking:
		animated_sprite.play("attack")
		attacking == false
		return
	
	if velocity == Vector2.ZERO:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("moving")
		animated_sprite.flip_h = velocity.x >= 0

func _process(delta):
	var distance_to_character = transform.origin.distance_to(character.transform.origin)
	
	path = nav_2d.get_simple_path(self.global_position, character.global_position)
	velocity = move()
	
	if !animated_sprite.is_playing() || !animated_sprite.animation == "attack":
		if distance_to_character <= attack_range:
			attack()
		
		animate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_slide(velocity)
