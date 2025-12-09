class_name Def

class General:
	const PROJECT_NAME: StringName = "vngine"
	
	const INPUT_LOCKED_SCENES: Array[Scenes] = [Scenes.NONE]

class Paths:
	const CONFIG: StringName = "user://user.cfg"
	const TITLE_THEME: StringName = "res://VNgine/Default/Music/msx_living_to_see_it.mp3"
	const INTRO: StringName = "res://VNgine/Default/Videos/intro.ogv"
	const SFX_SELECT: StringName = "res://VNgine/Default/SFX/ui_select.mp3"

class Defaults:
	# Only these keys get saved to user.cfg
	const USER_SETTINGS: Array[StringName] = [
		"music_volume", "sfx_volume", "fullscreen", "skip_unread", "text_speed_mult", "autoplay", "autosave", "auto_speed_mult", "parallax"
	]

	const DISPLAY: Dictionary = {
		"fullscreen": false,
		"window_size": Vector2i(1280, 720),
		"parallax": true,
			
		"parallax_strength": 8.0,
		"parallax_smoothing": 0.4,
	}
	const AUDIO: Dictionary = {
		"music_volume": 0.7,
		"sfx_volume": 0.7,
	}
	const STORY: Dictionary = {
		"auto_speed_mult": 1.8,
		"skip_unread": false,
		"autoplay": false,
		
		"auto_advance_delay": 2.0,
		"log_max_entries": 20,
	}
	const TEXT: Dictionary = {
		"text_speed_mult": 1.8,
			
		"base_cps": 50.0,
		"min_cps": 20.0,
		"max_cps": 60.0,
		"reference_length": 50,
		"pause_period": 0.2,
		"pause_comma": 0.1,
		"pause_ellipsis": 0.3,
		"pause_emphasis": 0.15,
	}
	const IMAGE_EXT: Array = [".webp", ".jpg", ".jpeg", ".png"]
	const AUDIO_EXT: Array = [".mp3", ".ogg", ".wav"]
	const VIDEO_EXT: StringName = ".ogv"
	const SAVE_EXT: StringName = ".sav"

	const STAGE: Dictionary = {
		"slot_left": 0.25,
		"slot_center": 0.5,
		"slot_right": 0.75,
		"flex_0": [0.5],
		"flex_1": [0.35, 0.65],
		"flex_2": [0.2, 0.5, 0.8],
		"flex_3": [0.15, 0.38, 0.62, 0.85],
		"flex_4": [0.1, 0.3, 0.5, 0.7, 0.9],
		"max_characters": 5,
		"char_y_offset": 0.9,
		"anim_duration": 0.5,
		"slide_offset": 200.0,
		"scale_closer": 1.2,
		"scale_away": 0.85,

	}

	const SAVES: Dictionary = {
		"autosave": true,
		"total_slots": 10,
		"autosave_slot": 1,
	}

	const INPUT: Dictionary = {
		"advance_cooldown": 100,
		"double_click_cooldown": 300,
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
