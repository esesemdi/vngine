class_name Title
extends Node

@export var main_layer: CanvasLayer
@export var ui_layer: CanvasLayer

signal scene_requested(new: Def.Scenes)
signal sfx_requested(path: String)

@onready var _ui: Dictionary = {
	"pause": %PauseTitle,
	"settings": %Settings
}

func _ready() -> void:
	_connect_scene_signals()
	_connect_ui_signals()
	hide_all_ui()

func toggle_ui(ui_name: String) -> void:
	if _ui.has(ui_name):
		_ui[ui_name].visible = not _ui[ui_name].visible

func hide_all_ui() -> void:
	for ui in _ui.values():
		ui.visible = false

func _connect_scene_signals() -> void:
	%NewGameBt.pressed.connect(_on_new_game_pressed)
	%LoadGameBt.pressed.connect(_on_load_game_pressed)
	%SettingsBt.pressed.connect(_on_settings_pressed)
	%QuitBt.pressed.connect(_on_quit_pressed)

func _connect_ui_signals() -> void:
	InputMan.cancel_pressed.connect(_on_cancel_pressed)
	%PauseTitle.return_requested.connect(_on_return_requested)
	%PauseTitle.sfx_requested.connect(_on_sfx_requested)
	%Settings.return_requested.connect(_on_return_requested)
	%Settings.sfx_requested.connect(_on_sfx_requested)

func _on_new_game_pressed() -> void:
	sfx_requested.emit(Def.Paths.SFX_SELECT)
	# CHANGE
	scene_requested.emit(Def.Scenes.NONE)
func _on_load_game_pressed() -> void:
	sfx_requested.emit(Def.Paths.SFX_SELECT)
	# CHANGE
	scene_requested.emit(Def.Scenes.NONE)
func _on_settings_pressed() -> void:
	sfx_requested.emit(Def.Paths.SFX_SELECT)
	toggle_ui("settings")
func _on_quit_pressed() -> void:
	sfx_requested.emit(Def.Paths.SFX_SELECT)
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

func _on_return_requested() -> void:
	hide_all_ui()
func _on_cancel_pressed() -> void:
	if not _ui["pause"].visible and not _ui["settings"].visible:
		toggle_ui("pause")
	else:
		hide_all_ui()
func _on_sfx_requested(sfx_name: StringName):
	sfx_requested.emit(sfx_name)
