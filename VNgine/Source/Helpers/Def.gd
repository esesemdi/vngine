class_name Def

class Const:
	const PROJECT_NAME: StringName = "vngine"
	
	const INPUT_LOCKED_SCENES: Array[Scenes] = [Scenes.NONE]
	const PATH_CONFIG: StringName = "user://user.cfg"
	
	const TITLE_THEME_PATH: StringName = "res://VNgine/Default/Music/darius_falsewood.mp3"
	const INTRO_PATH: StringName = "res://VNgine/Default/Videos/intro.ogv"
	const SFX_SELECT: StringName = "res://VNgine/Default/SFX/ui_select.mp3"
	
	# Only these keys get saved to user.cfg
	const USER_SETTINGS: Array[StringName] = [
		"music_volume", "sfx_volume", "fullscreen", "skip_unread", "text_speed_mult", "autoplay", "autosave", "auto_speed_mult", "parallax"
	]
	const DEFAULTS: Dictionary = {
		"display": {
			"fullscreen": false,
			"window_size": Vector2i(1280, 720),
			"parallax": true,
			
			"parallax_strength": 8.0,
			"parallax_smoothing": 0.4,
		},
		"audio": {
			"music_volume": 0.7,
			"sfx_volume": 0.7,
		},
		"story_scene": {
			"auto_speed_mult": 1.8,
			"skip_unread": false,
			"autoplay": false,
			
			"auto_advance_delay": 2.0,
			"log_max_entries": 20,
		},
		"text": {
			"text_speed_mult": 1.8,
			
			"base_cps": 50.0,
			"min_cps": 20.0,
			"max_cps": 60.0,
			"reference_length": 50,
			"pause_period": 0.2,
			"pause_comma": 0.1,
			"pause_ellipsis": 0.3,
			"pause_emphasis": 0.15,
		},
		"file_extensions": {
			"image": ["webp", "png", "jpg", "jpeg"],
			"audio": ["mp3", "ogg", "wav"],
			"video": "ogv",
			"save": ".sav",
		},
		"stage": {
			"slot_positions": {
				"left": 0.25,
				"center": 0.5,
				"right": 0.75,
			},
			"flex_positions": {
				1: [0.5],
				2: [0.35, 0.65],
				3: [0.2, 0.5, 0.8],
				4: [0.15, 0.38, 0.62, 0.85],
				5: [0.1, 0.3, 0.5, 0.7, 0.9],
			},
			"max_characters": 5,
			"character_y": 0.9,
		},
		"animations": {
			"duration": 0.5,
			"slide_offset": 200.0,
			"scale_closer": 1.15,
			"scale_away": 0.85,
		},
		"save_system": {
			"autosave": true,
			
			"slots_count": 10,
			"autosave_slot": 1,
		},
		"input": {
			"advance_cooldown": 100,
			"double_click_time": 300,
		},
	}

enum Scenes {
	NONE,
	
	TITLE,
	STORY,
	SETTINGS,
	GALLERY,
	LOAD,
	SAVE,
	
	CUSTOM,
}
