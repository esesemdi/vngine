extends Node

signal config_loaded_and_applied
signal setting_changed(setting: String, value: Variant)

var _settings: Dictionary = {}
var _config: ConfigFile = ConfigFile.new()

# Maps section names to their Def.Defaults constants
const SECTION_MAP: Dictionary = {
	"display": "DISPLAY",
	"audio": "AUDIO",
	"story": "STORY",
	"text": "TEXT",
	"saves": "SAVES",
	"input": "INPUT",
	"stage": "STAGE",
}

func _ready() -> void:
	_load_settings()
	_apply_all_settings()
	_connect_to_signals()
	config_loaded_and_applied.emit()

#region PUBLIC API
func get_setting(section: String, key: String) -> Variant:
	var current_value = _settings.get(section, {}).get(key)
	if current_value != null:
		return current_value
	return _get_default(section, key)

func get_section(setting: String) -> String:
	for section in SECTION_MAP:
		var defaults := _get_section_defaults(section)
		if defaults.has(setting):
			return section
	return ""
#endregion

#region PRIVATE
func _get_section_defaults(section: String) -> Dictionary:
	match section:
		"display": return Def.Defaults.DISPLAY
		"audio": return Def.Defaults.AUDIO
		"story": return Def.Defaults.STORY
		"text": return Def.Defaults.TEXT
		"saves": return Def.Defaults.SAVES
		"input": return Def.Defaults.INPUT
		"stage": return Def.Defaults.STAGE
	return {}

func _get_default(section: String, key: String) -> Variant:
	var defaults := _get_section_defaults(section)
	return defaults.get(key)

func _connect_to_signals() -> void:
	InputMan.setting_toggled.connect(_on_setting_toggled.bind("fullscreen"))
	get_tree().node_added.connect(_connect_scene_signals)

func _connect_scene_signals(node: Node) -> void:
	if node is Settings:
		node.value_changed.connect(_on_value_changed)
		node.setting_toggled.connect(_on_setting_toggled)
		call_deferred("_populate_settings_ui", node)

func _populate_settings_ui(settings_scene: Settings) -> void:
	settings_scene.music_volume.set_value_no_signal(get_setting("audio", "music_volume"))
	settings_scene.sfx_volume.set_value_no_signal(get_setting("audio", "sfx_volume"))
	settings_scene.fullscreen.set_pressed_no_signal(get_setting("display", "fullscreen"))
	settings_scene.parallax.set_pressed_no_signal(get_setting("display", "parallax"))
	settings_scene.skip_unread.set_pressed_no_signal(get_setting("story", "skip_unread"))
	settings_scene.autoplay.set_pressed_no_signal(get_setting("story", "autoplay"))
	settings_scene.autosave.set_pressed_no_signal(get_setting("saves", "autosave"))
	settings_scene.text_speed_mult.set_value_no_signal(get_setting("text", "text_speed_mult"))
	settings_scene.auto_speed_mult.set_value_no_signal(get_setting("story", "auto_speed_mult"))

func _load_settings() -> void:
	# Initialize settings with defaults for user-saveable settings only
	for setting in Def.Defaults.USER_SETTINGS:
		var section := get_section(setting)
		if section.is_empty():
			continue
		if not _settings.has(section):
			_settings[section] = {}
		_settings[section][setting] = _get_default(section, setting)
	
	# Load from config file
	if _config.load(Def.Paths.CONFIG) != OK:
		_save_settings()
		return
	
	# Override defaults with saved values
	for section in _settings:
		for setting in _settings[section]:
			if _config.has_section_key(section, setting):
				_settings[section][setting] = _config.get_value(section, setting)

func _save_settings() -> void:
	for section in _settings:
		for setting in _settings[section]:
			_config.set_value(section, setting, _settings[section][setting])
	_config.save(Def.Paths.CONFIG)

func _apply_all_settings() -> void:
	for section in _settings:
		for setting in _settings[section]:
			_apply_setting(setting, _settings[section][setting])

func _set_setting(setting: String, value: Variant) -> void:
	var section := get_section(setting)
	if section.is_empty():
		return
	_settings[section][setting] = value
	_apply_setting(setting, value)
	_save_settings()
	setting_changed.emit(setting, value)

func _apply_setting(setting: String, value: Variant) -> void:
	match setting:
		"music_volume":
			# AudioMan.music_volume = value
			pass
		"sfx_volume":
			# AudioMan.sfx_volume = value
			pass
		"fullscreen":
			if value:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				DisplayServer.window_set_size(Def.Defaults.DISPLAY.window_size)
				_center_window()

func _center_window() -> void:
	var screen := DisplayServer.screen_get_size()
	var window := DisplayServer.window_get_size()
	DisplayServer.window_set_position((screen - window) / 2)
#endregion

#region SIGNAL HANDLERS
func _on_value_changed(setting: String, value: Variant) -> void:
	_set_setting(setting, value)

func _on_setting_toggled(setting: String, value: bool) -> void:
	_set_setting(setting, value)

func _on_settings_saved() -> void:
	_save_settings()
#endregion
