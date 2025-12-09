class_name Settings
extends Node

@export var main_layer: CanvasLayer
@export var component_layer: CanvasLayer

@onready var music_volume: HSlider = %MusicVolume
@onready var sfx_volume: HSlider = %SFXVolume

@onready var fullscreen: CheckBox = %Fullscreen
@onready var parallax: CheckBox = %Parallax

@onready var skip_unread: CheckBox = %SkipUnread
@onready var autoplay: CheckBox = %Autoplay
@onready var autosave: CheckBox = %Autosave

@onready var text_speed_mult: HSlider = %TextSpeedMult
@onready var auto_speed_mult: HSlider = %AutoSpeedMult

@onready var done: Button = %Done

# To ShotCaller.gd
signal goback_requested

# To ConfigMan.gd
signal value_changed(setting: String, value: Variant)
signal setting_toggled(setting: String)

# To MediaMan.gd
signal sfx_requested(path: StringName)

func _ready() -> void:
	_connect_controls()

#region PRIVATE
func _connect_controls() -> void:
	music_volume.value_changed.connect(_on_value_changed.bind("music_volume"))
	sfx_volume.value_changed.connect(_on_value_changed.bind("sfx_volume"))
	fullscreen.toggled.connect(_on_setting_toggled.bind("fullscreen"))
	skip_unread.toggled.connect(_on_setting_toggled.bind("skip_unread"))
	parallax.toggled.connect(_on_setting_toggled.bind("parallax"))
	autoplay.toggled.connect(_on_setting_toggled.bind("autoplay"))
	autosave.toggled.connect(_on_setting_toggled.bind("autosave"))
	text_speed_mult.value_changed.connect(_on_value_changed.bind("text_speed_mult"))
	auto_speed_mult.value_changed.connect(_on_value_changed.bind("auto_speed_mult"))
	
	done.pressed.connect(_on_done_pressed)
	
			
## SIGNALS
func _on_value_changed(value: float, setting: String) -> void:
	value_changed.emit(setting, value)
func _on_setting_toggled(value: bool, setting: String):
	setting_toggled.emit(setting, value)
func _on_done_pressed() -> void:
	sfx_requested.emit(Def.Paths.SFX_SELECT)
	goback_requested.emit()
#endregion
