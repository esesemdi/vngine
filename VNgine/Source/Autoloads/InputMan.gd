extends Node

signal return_requested
signal pause_toggled
signal backlog_toggled
signal skip_toggled
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
		if ShotCaller.current_scene == Def.Scenes.SETTINGS or \
		ShotCaller.current_scene == Def.Scenes.GALLERY or \
		ShotCaller.current_scene == Def.Scenes.LOAD or \
		ShotCaller.current_scene == Def.Scenes.SAVE:
			return_requested.emit()
		else:
			pause_toggled.emit()
			
	elif event.is_action_pressed("story_log"):
		if ShotCaller.current_scene == Def.Scenes.STORY:
			backlog_toggled.emit()
			
	elif event.is_action_pressed("story_skip"):
		if ShotCaller.current_scene == Def.Scenes.STORY:
			skip_toggled.emit()

func _on_input_lock_toggled() -> void:
	input_locked = not input_locked
