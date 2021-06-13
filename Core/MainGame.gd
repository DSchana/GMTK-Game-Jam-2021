extends Node2D

onready var mob = load("res://NPC/NPC.tscn")
onready var powerup = load("res://PowerUps/PowerUp.tscn")

func _ready():
	randomize()
	$WreckingBall.character = $Character
	$Character.wreckingBall = $WreckingBall
	
	$CanvasLayer/GUIControl.connect("set_skin", $Character, "setSkin")
	$CanvasLayer/GUIControl.connect("game_start", self, "setUpLabyrinth")
	$Character.connect("set_health", $CanvasLayer/GUIControl, "setGameHealth")

func setUpLabyrinth():
	$Character.updateHealth()
	
	#player spawn
	var spawn = $PlayerSpawnPoints.get_child(randi()%$PlayerSpawnPoints.get_child_count())
	$Character.position = spawn.position
	$WreckingBall.position = spawn.position
	
	#monster spawn
	for p in $MonsterSpawnPoints.get_children():
		var new_mob = mob.instance()
		new_mob.position = p.position
		#new_mob.nav_2d = $GameMap/Navigation2D
		#new_mob.character = $Character
		add_child(new_mob)
	
	for p in $PowerUpSpawnPoints.get_children():
		var new_powerup = powerup.instance()
		new_powerup.position = p.position
		add_child(new_powerup)
