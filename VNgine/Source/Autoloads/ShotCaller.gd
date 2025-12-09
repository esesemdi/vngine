## ======================================================================== ##
##	SHOTCALLER.gd: Boots up your game, manages state, helps with loading
##	scenes, and tracking global variables.
## ======================================================================== ##
extends Node

signal scene_changed(new: Def.Scenes)

var current_scene: Def.Scenes = Def.Scenes.NONE
var _scenes: Dictionary = {}

func _ready() -> void:
	_preload_scenes()
	Util.print_logo()
	MediaMan.play_video(Def.Paths.INTRO)
	change_scene(Def.Scenes.TITLE)

#region PUBLIC
func change_scene(scene_enum: Def.Scenes) -> void:
	call_deferred("_change_scene_deferred", _scenes[scene_enum])
	current_scene = scene_enum
	scene_changed.emit(scene_enum)
#endregion

#region PRIVATE
func _change_scene_deferred(scene: PackedScene) -> void:
	get_tree().change_scene_to_packed(scene)
	
func _preload_scenes() -> void:
	_scenes[Def.Scenes.TITLE] = preload("res://VNgine/Default/Scenes/Title/TitleScene.tscn")
	#_scenes[Def.Scenes.GALLERY] = preload("res://VNgine/Default/Scenes/Gallery/scn_gallery.tscn")
	#_scenes[Def.Scenes.STORY] = preload("res://VNgine/Default/Scenes/Story/scn_story.tscn")
#endregion
