extends Control

enum UI_STATE{MAIN, CHARACTER_SELECT, OPTIONS, CREDITS, GAME, GAME_PAUSE}

export var current_state = UI_STATE.MAIN
var previous_state = UI_STATE.MAIN # only used for options menu

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

func onMainMenuToExit():
	if current_state == UI_STATE.MAIN:
		print("quit")
		get_tree().quit()
