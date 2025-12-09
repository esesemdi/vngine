class_name Settings
extends Control

@onready var music_volume: HSlider = %MusicVolume
@onready var sfx_volume: HSlider = %SFXVolume

@onready var fullscreen: CheckBox = %Fullscreen
@onready var parallax: CheckBox = %Parallax

@onready var skip_unread: CheckBox = %SkipUnread
@onready var autoplay: CheckBox = %Autoplay
@onready var autosave: CheckBox = %Autosave

@onready var text_speed_mult: HSlider = %TextSpeedMult
@onready var auto_speed_mult: HSlider = %AutoSpeedMult

@onready var save: Button = %Save

signal changes_saved
signal changes_cancelled

var _original_settings: Dictionary = {}

func _ready() -> void:
	call_deferred("_populate_settings")
	_connect_controls()

#region PUBLIC API
## Call this when opening the settings UI to snapshot current values
func store_original_settings() -> void:
	_original_settings = {
		"music_volume": ConfigMan.get_setting("audio", "music_volume"),
		"sfx_volume": ConfigMan.get_setting("audio", "sfx_volume"),
		"fullscreen": ConfigMan.get_setting("display", "fullscreen"),
		"parallax": ConfigMan.get_setting("display", "parallax"),
		"skip_unread": ConfigMan.get_setting("story", "skip_unread"),
		"autoplay": ConfigMan.get_setting("story", "autoplay"),
		"autosave": ConfigMan.get_setting("saves", "autosave"),
		"text_speed_mult": ConfigMan.get_setting("text", "text_speed_mult"),
		"auto_speed_mult": ConfigMan.get_setting("story", "auto_speed_mult"),
	}

## Call this to revert all settings to their original values
func revert_settings() -> void:
	for setting in _original_settings:
		ConfigMan.set_setting(setting, _original_settings[setting])
	_populate_settings()

## Call this when the user cancels
func cancel() -> void:
	MediaMan.play_sfx(Def.Paths.SFX_SELECT)
	revert_settings()
	changes_cancelled.emit()
#endregion

#region PRIVATE
func _populate_settings() -> void:
	music_volume.set_value_no_signal(ConfigMan.get_setting("audio", "music_volume"))
	sfx_volume.set_value_no_signal(ConfigMan.get_setting("audio", "sfx_volume"))
	fullscreen.set_pressed_no_signal(ConfigMan.get_setting("display", "fullscreen"))
	parallax.set_pressed_no_signal(ConfigMan.get_setting("display", "parallax"))
	skip_unread.set_pressed_no_signal(ConfigMan.get_setting("story", "skip_unread"))
	autoplay.set_pressed_no_signal(ConfigMan.get_setting("story", "autoplay"))
	autosave.set_pressed_no_signal(ConfigMan.get_setting("saves", "autosave"))
	text_speed_mult.set_value_no_signal(ConfigMan.get_setting("text", "text_speed_mult"))
	auto_speed_mult.set_value_no_signal(ConfigMan.get_setting("story", "auto_speed_mult"))

func _connect_controls() -> void:
	music_volume.value_changed.connect(_on_setting_changed.bind("music_volume"))
	sfx_volume.value_changed.connect(_on_setting_changed.bind("sfx_volume"))
	fullscreen.toggled.connect(_on_setting_changed.bind("fullscreen"))
	skip_unread.toggled.connect(_on_setting_changed.bind("skip_unread"))
	parallax.toggled.connect(_on_setting_changed.bind("parallax"))
	autoplay.toggled.connect(_on_setting_changed.bind("autoplay"))
	autosave.toggled.connect(_on_setting_changed.bind("autosave"))
	text_speed_mult.value_changed.connect(_on_setting_changed.bind("text_speed_mult"))
	auto_speed_mult.value_changed.connect(_on_setting_changed.bind("auto_speed_mult"))
	
	save.pressed.connect(_on_save_pressed)
	
			
## SIGNALS
func _on_setting_changed(value: float, setting: String) -> void:
	ConfigMan.set_setting(setting, value)
func _on_save_pressed() -> void:
	MediaMan.play_sfx(Def.Paths.SFX_SELECT)
	ConfigMan.save_settings()
	changes_saved.emit()
#endregion
