extends Node

signal cancel_pressed
signal log_pressed
signal skip_pressed

signal setting_toggled(setting: String)
signal intro_skip_requested

var input_locked: bool = false

func _input(event: InputEvent) -> void:
	if input_locked or ShotCaller.current_scene in Def.General.INPUT_LOCKED_SCENES:
		get_viewport().set_input_as_handled()
		return
	if event.is_pressed() and not event.is_echo():
		intro_skip_requested.emit()
	if event.is_action_pressed("fullscreen"):
		setting_toggled.emit("fullscreen")
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		cancel_pressed.emit()
			
	elif event.is_action_pressed("story_log") and ShotCaller.current_scene == Def.Scenes.STORY:
		log_pressed.emit()
			
	elif event.is_action_pressed("story_skip") and ShotCaller.current_scene == Def.Scenes.STORY:
		skip_pressed.emit()

func lock_input() -> void:
	input_locked = true

func unlock_input() -> void:
	input_locked = false

func is_locked() -> bool:
	return input_locked
