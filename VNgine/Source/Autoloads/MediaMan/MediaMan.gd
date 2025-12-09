extends Node

signal video_finished

var _music_player: AudioStreamPlayer
var _sfx_player: AudioStreamPlayer
var _video_player: VideoStreamPlayer
var _video_canvas: CanvasLayer
var _pending_music: String = ""

func _ready() -> void:
	_setup_audio_players()
	_connect_to_signals()

#region SETUP
func _setup_audio_players() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = "Music"
	add_child(_music_player)
	
	_sfx_player = AudioStreamPlayer.new()
	_sfx_player.bus = "SFX"
	add_child(_sfx_player)

func _connect_to_signals() -> void:
	get_tree().node_added.connect(_on_node_added)
	video_finished.connect(_on_video_finished_play_pending)
	ShotCaller.scene_changed.connect(_on_scene_changed)
	ConfigMan.setting_changed.connect(_on_setting_changed)
	InputMan.intro_skip_requested.connect(_on_intro_skip_requested)
#endregion

#region PUBLIC - VIDEO
func play_video(path: String) -> void:
	var stream: VideoStream = load(path) as VideoStream
	
	stop_music()
	
	_video_canvas = CanvasLayer.new()
	_video_canvas.layer = 20
	add_child(_video_canvas)
	
	var container: Control = Control.new()
	container.set_anchors_preset(Control.PRESET_FULL_RECT)
	container.anchor_right = 1.0
	container.anchor_bottom = 1.0
	_video_canvas.add_child(container)
	
	var intro_volume: float = linear_to_db(ConfigMan.get_setting("audio", "music_volume"))
	
	_video_player = VideoStreamPlayer.new()
	_video_player.volume_db = intro_volume if intro_volume >= 0.1 else linear_to_db(0.1)
	_video_player.expand = true
	_video_player.set_anchors_preset(Control.PRESET_FULL_RECT)
	_video_player.anchor_right = 1.0
	_video_player.anchor_bottom = 1.0
	_video_player.offset_right = 0.0
	_video_player.offset_bottom = 0.0
	_video_player.stream = stream
	_video_player.finished.connect(_on_video_finished)
	container.add_child(_video_player)
	_video_player.play()

func skip_video() -> void:
	if _video_player:
		_on_video_finished()

func is_video_playing() -> bool:
	return _video_player != null
#endregion

#region PUBLIC - MUSIC
func play_music(path: String) -> void:
	if is_video_playing():
		_pending_music = path
		return
	
	_play_music_internal(path)

func stop_music() -> void:
	_pending_music = ""
	if _music_player:
		_music_player.stop()

func queue_music(path: String) -> void:
	_pending_music = path

func _play_music_internal(path: String) -> void:
	var stream: AudioStream = load(path) as AudioStream
	
	_music_player.stream = stream
	_music_player.volume_db = linear_to_db(ConfigMan.get_setting("audio", "music_volume"))
	_music_player.play()
#endregion

#region PUBLIC - SFX
func play_sfx(path: String) -> void:
	var stream: AudioStream = load(path) as AudioStream
	
	_sfx_player.stream = stream
	_sfx_player.volume_db = linear_to_db(ConfigMan.get_setting("audio", "sfx_volume"))
	_sfx_player.play()
#endregion

#region SIGNAL HANDLERS
func _on_node_added(node: Node) -> void:
	if node is Title:
		node.sfx_requested.connect(_on_sfx_requested)
	elif node is Settings:
		node.sfx_requested.connect(_on_sfx_requested)
func _on_video_finished() -> void:
	if _video_player:
		_video_player.queue_free()
		_video_player = null
	if _video_canvas:
		_video_canvas.queue_free()
		_video_canvas = null
	video_finished.emit()
func _on_video_finished_play_pending() -> void:
	if _pending_music != "":
		var path: String = _pending_music
		_pending_music = ""
		_play_music_internal(path)
func _on_scene_changed(scene: Def.Scenes) -> void:
	if scene == Def.Scenes.TITLE:
		play_music(Def.Const.TITLE_THEME_PATH)
	else:
		stop_music()
func _on_sfx_requested(path: String) -> void:
	play_sfx(path)
func _on_setting_changed(setting: String, value: Variant) -> void:
	match setting:
		"music_volume":
			_music_player.volume_db = linear_to_db(value)
		"sfx_volume":
			_sfx_player.volume_db = linear_to_db(value)
func _on_intro_skip_requested() -> void:
	skip_video()
#endregion
