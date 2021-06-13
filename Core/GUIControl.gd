extends Control

enum UI_STATE{MAIN, CHARACTER_SELECT, OPTIONS, CREDITS, GAME, GAME_PAUSE, LOSE}

export var current_state = UI_STATE.MAIN
var previous_state = UI_STATE.MAIN # only used for options menu

var character2_unlocked = true

onready var heart_scene = load("res://UI/Heart.tscn")

signal game_start
signal set_skin(value)

func _ready():
	get_tree().paused = true # prevents game from running in background
	$MainMenu/ButtonListFlat/TopBar/StartButton.connect("pressed", self, "onMainToCharacterSelect")
	$MainMenu/ButtonListFlat/BottomBar/OptionsButton.connect("pressed", self, "onMainToOptions")
	$MainMenu/ButtonListFlat/BottomBar/CreditsButton.connect("pressed", self, "onMainToCredits")
	$MainMenu/ButtonListFlat/BottomBar/ExitButton.connect("pressed", self, "onMainMenuToExit")
	$CharacterSelect/StartButton.connect("pressed", self, "onCharacterSelectToGame")
	$PauseMenu/VBoxContainer/ResumeButton.connect("pressed", self, "onGameResume")
	$PauseMenu/VBoxContainer/OptionsButton.connect("pressed", self, "onPauseToOptions")
	$PauseMenu/VBoxContainer/ExitButton.connect("pressed", self, "onPauseToMainMenu")
	
	#character select
	$CharacterSelect/HBoxContainer/Character1/TextureButton.connect("pressed", self, "selectCharacter1")
	$CharacterSelect/HBoxContainer/Character2/TextureButton.connect("pressed", self, "selectCharacter2")
	
	$RestartScreen/Reset.connect("pressed", self, "onBackToMenu")
	
	if character2_unlocked:
		$CharacterSelect/HBoxContainer/Character2/Contents/VBoxContainer/CenterContainer/Unlocked.visible = true
		$CharacterSelect/HBoxContainer/Character2/Contents/VBoxContainer/CenterContainer/Locked.visible = false
		$CharacterSelect/HBoxContainer/Character2/Contents/VBoxContainer/CenterContainer/Lock.visible = false
	

func restart():
	_ready()

func _process(delta):
	if current_state == UI_STATE.MAIN:
		pass
	elif current_state == UI_STATE.CHARACTER_SELECT:
		if Input.is_action_pressed("ui_cancel"):
			onCharacterSelectToMain()
	elif current_state == UI_STATE.OPTIONS:
		if Input.is_action_pressed("ui_cancel"):
			if previous_state == UI_STATE.MAIN:
				onOptionsToMain()
			elif previous_state == UI_STATE.GAME_PAUSE:
				onOptionsToPause()
	elif current_state == UI_STATE.CREDITS:
		if Input.is_action_pressed("ui_cancel"):
			onCreditsToMain()
	elif current_state == UI_STATE.GAME:
		if Input.is_action_just_pressed("ui_cancel"):
			onGamePause()
	elif current_state == UI_STATE.GAME_PAUSE:
		if Input.is_action_just_pressed("ui_cancel"):
			onGameResume()

func onMainToCharacterSelect():
	if current_state == UI_STATE.MAIN:
		current_state = UI_STATE.CHARACTER_SELECT
		$MainMenu.visible = false
		$CharacterSelect.visible = true

func onMainToOptions():
	if current_state == UI_STATE.MAIN:
		current_state = UI_STATE.OPTIONS
		$MainMenu.visible = false
		$OptionsMenu.visible = true

func onMainToCredits():
	if current_state == UI_STATE.MAIN:
		current_state = UI_STATE.CREDITS
		$MainMenu.visible = false
		$Credits.visible = true

func onCharacterSelectToMain():
	if current_state == UI_STATE.CHARACTER_SELECT:
		current_state = UI_STATE.MAIN
		$MainMenu.visible = true
		$CharacterSelect.visible = false

func onCharacterSelectToGame():
	if current_state == UI_STATE.CHARACTER_SELECT:
		current_state = UI_STATE.GAME
		$Background.visible = false
		$CharacterSelect.visible = false
		$GameGUI.visible = true
		emit_signal("game_start")
		
		get_tree().paused = false

func onOptionsToMain():
	if current_state == UI_STATE.OPTIONS:
		current_state = UI_STATE.MAIN
		$MainMenu.visible = true
		$OptionsMenu.visible = false

func onOptionsToPause():
	if current_state == UI_STATE.OPTIONS:
		current_state = UI_STATE.GAME_PAUSE
		$PauseMenu.visible = true
		$OptionsMenu.visible = false

func onCreditsToMain():
	if current_state == UI_STATE.CREDITS:
		current_state = UI_STATE.MAIN
		$MainMenu.visible = true
		$Credits.visible = false

func onGamePause():
	if current_state == UI_STATE.GAME:
		current_state = UI_STATE.GAME_PAUSE
		get_tree().paused = true
		$PauseMenu.visible = true
		previous_state = current_state

func onGameResume():
	if current_state == UI_STATE.GAME_PAUSE:
		current_state = UI_STATE.GAME
		get_tree().paused = false
		$PauseMenu.visible = false

func onPauseToMainMenu():
	if current_state == UI_STATE.GAME_PAUSE:
		current_state = UI_STATE.MAIN
		$Background.visible = true
		$MainMenu.visible = true
		$PauseMenu.visible = false
		$GameGUI.visible = false
		previous_state = current_state

func onPauseToOptions():
	if current_state == UI_STATE.GAME_PAUSE:
		current_state = UI_STATE.OPTIONS
		$PauseMenu.visible = false
		$OptionsMenu.visible = true

func selectCharacter1():
	if current_state == UI_STATE.CHARACTER_SELECT:
		emit_signal("set_skin", "normal")
		$CharacterSelect/HBoxContainer/Character1/SelectionNormal.visible = true
		$CharacterSelect/HBoxContainer/Character1/SelectionChosen.visible = false
		$CharacterSelect/HBoxContainer/Character2/SelectionNormal.visible = false
		$CharacterSelect/HBoxContainer/Character2/SelectionChosen.visible = true

func selectCharacter2():
	if current_state == UI_STATE.CHARACTER_SELECT and character2_unlocked:
		emit_signal("set_skin", "golden")
		$CharacterSelect/HBoxContainer/Character1/SelectionNormal.visible = false
		$CharacterSelect/HBoxContainer/Character1/SelectionChosen.visible = true
		$CharacterSelect/HBoxContainer/Character2/SelectionNormal.visible = true
		$CharacterSelect/HBoxContainer/Character2/SelectionChosen.visible = false
		
func onEndGameScreen():
	if current_state == UI_STATE.GAME:
		current_state = UI_STATE.LOSE
		$GameGUI.visible = false
		$RestartScreen.visible = true
		get_tree().paused = false

func onBackToMenu():
	if current_state == UI_STATE.LOSE:
		current_state = UI_STATE.MAIN
		$Background.visible = true
		$RestartScreen.visible = false
		$MainMenu.visible = true

func setGameHealth(current, total):
	if current < 0:
		current = 0
		
	if total % 2 == 1:
		total += 1
	total /= 2
	
	var list = $GameGUI/MarginContainer/HealthBar
	for n in list.get_children():
		list.remove_child(n)
		n.queue_free()
	
	for i in range(total):
		var heart = heart_scene.instance()
		if current == 0:
			heart.get_node("Empty").visible = true
		elif current == 1:
			current -= 1
			heart.get_node("Half").visible = true
		else:
			current -= 2
			heart.get_node("Full").visible = true
		list.add_child(heart)

func onMainMenuToExit():
	if current_state == UI_STATE.MAIN:
		print("quit")
		get_tree().quit()
