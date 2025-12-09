class_name Title
extends Node

@export var main_layer: CanvasLayer
@export var ui_layer: CanvasLayer

@onready var _ui: Dictionary = {
	"pause": %PauseTitle,
	"settings": %Settings
}

func _ready() -> void:
	_connect_scene_signals()
	_connect_ui_signals()
	hide_all_ui()



func show_ui(ui_name: String) -> void:
	if _ui.has(ui_name):
		_ui[ui_name].visible = true

func hide_ui(ui_name: String) -> void:
	if _ui.has(ui_name):
		_ui[ui_name].visible = false

func hide_all_ui() -> void:
	for ui in _ui.values():
		ui.visible = false

#region PRIVATE
func _connect_scene_signals() -> void:
	%NewGameBt.pressed.connect(_on_new_game_pressed)
	%LoadGameBt.pressed.connect(_on_load_game_pressed)
	%SettingsBt.pressed.connect(_on_settings_pressed)
	%QuitBt.pressed.connect(_on_quit_pressed)

func _connect_ui_signals() -> void:
	InputMan.cancel_pressed.connect(_on_cancel_pressed)
	%PauseTitle.quit_confirmed.connect(_on_quit_confirmed)
	%PauseTitle.quit_cancelled.connect(_on_quit_cancelled)
	%Settings.changes_saved.connect(_on_changes_saved)
	%Settings.changes_cancelled.connect(_on_changes_cancelled)
#endregion

#region SIGNALS
## From MainLayer
func _on_new_game_pressed() -> void:
	MediaMan.play_sfx(Def.Paths.SFX_SELECT)
	# CHANGE
	# SceneMan.change_scene(Def.Scenes.STORY)
func _on_load_game_pressed() -> void:
	MediaMan.play_sfx(Def.Paths.SFX_SELECT)
	# CHANGE
	# SceneMan.change_scene(Def.Scenes.LOAD)
func _on_settings_pressed() -> void:
	MediaMan.play_sfx(Def.Paths.SFX_SELECT)
	%Settings.store_original_settings()
	show_ui("settings")
func _on_quit_pressed() -> void:
	MediaMan.play_sfx(Def.Paths.SFX_SELECT)
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
func _on_cancel_pressed() -> void:
	if _ui["settings"].visible:
		# Cancel settings and revert changes
		%Settings.cancel()
	elif _ui["pause"].visible:
		hide_all_ui()
	else:
		show_ui("pause")

## From Settings.gd
func _on_changes_saved() -> void:
	hide_all_ui()
func _on_changes_cancelled() -> void:
	hide_all_ui()

## From PAUSE.gd
func _on_quit_cancelled() -> void:
	hide_all_ui()
func _on_quit_confirmed() -> void:
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
#endregion
