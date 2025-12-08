## ======================================================================== ##
##	SHOTCALLER.gd: Boots up your game, manages state, helps with loading
##	scenes, and tracking global variables.
## ======================================================================== ##
extends Node

signal scene_changed(new: Def.Scenes)

var previous_scene: Def.Scenes = Def.Scenes.NONE
var current_scene: Def.Scenes = Def.Scenes.NONE
	
var _scenes: Dictionary = {}

func _ready() -> void:
	Util.print_logo()
	_preload_scenes()
	_connect_to_signals()
	MediaMan.play_video(Def.Const.INTRO_PATH)
	change_scene(Def.Scenes.TITLE)


#region PUBLIC
func change_scene(scene_enum: Def.Scenes) -> void:
	call_deferred("_change_scene_deferred", _scenes[scene_enum])
	previous_scene = current_scene
	current_scene = scene_enum
	scene_changed.emit(scene_enum)
#endregion

#region PRIVATE
func _connect_to_signals() -> void:
	get_tree().node_added.connect(_connect_scene_signals)

func _change_scene_deferred(scene: PackedScene) -> void:
	get_tree().change_scene_to_packed(scene)
	
func _preload_scenes() -> void:
	_scenes[Def.Scenes.TITLE] = preload("res://VNgine/Default/Scenes/Title/TitleScene.tscn")
	_scenes[Def.Scenes.SETTINGS] = preload("res://VNgine/Default/Scenes/Settings/SettingsScene.tscn")
	#_scenes[Def.Scenes.GALLERY] = preload("res://VNgine/Default/Scenes/Gallery/scn_gallery.tscn")
	#_scenes[Def.Scenes.LOAD] = preload("res://VNgine/Default/Scenes/Load/scn_load.tscn")
	#_scenes[Def.Scenes.SAVE] = preload("res://VNgine/Default/Scenes/Save/scn_save.tscn")
	#_scenes[Def.Scenes.STORY] = preload("res://VNgine/Default/Scenes/Story/scn_story.tscn")

func _connect_scene_signals(node: Node) -> void:
	if node is Title:
		node.scene_requested.connect(_on_scene_requested)
		node.quit_requested.connect(_on_quit_requested)
	elif node is Settings:
		node.done_requested.connect(_on_done_requested)

## SIGNALS	
func _on_scene_requested(scene: Def.Scenes) -> void:
	change_scene(scene)
func _on_quit_requested() -> void:
	get_tree().quit()
func _on_done_requested() -> void:
	change_scene(previous_scene)
#endregion
