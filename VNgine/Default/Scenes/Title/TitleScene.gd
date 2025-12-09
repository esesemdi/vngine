class_name Title
extends Node

@export var main_layer: CanvasLayer
@export var component_layer: CanvasLayer

signal scene_requested(new: Def.Scenes)
signal quit_requested

signal sfx_requested(path: String)

var _components: Dictionary = {}

func _ready() -> void:
	InputMan.pause_toggled.connect(_on_pause_toggled)
	_check_components()
	_connect_buttons(self)
	hide_all_components()

#region PUBLIC
func toggle_component(component_name: String) -> void:
	if _components.has(component_name):
		_components[component_name].visible = not _components[component_name].visible

func hide_all_components() -> void:
	for component in _components.values():
		component.visible = false
#endregion

#region PRIVATE
func _check_components() -> void:
	for component in component_layer.get_children():
		_components[component.name.to_lower()] = component

func _connect_buttons(node: Node) -> void:
	for child in node.get_children():
		if child is BaseButton:
			var method_name: String = "_on_%s_pressed" % child.name.to_snake_case()
			if has_method(method_name):
				child.pressed.connect(Callable(self, method_name))
			else:
				push_error("No method %s defined for this button" % method_name)
	
		if child.get_child_count() > 0:
			_connect_buttons(child)

## SIGNALS
func _on_new_game_pressed() -> void:
	sfx_requested.emit(Def.Const.SFX_SELECT)
#	scene_requested.emit(Def.Scenes.STORY)
func _on_load_game_pressed() -> void:
	sfx_requested.emit(Def.Const.SFX_SELECT)
#	scene_requested.emit(Def.Scenes.LOAD)
func _on_settings_pressed() -> void:
	sfx_requested.emit(Def.Const.SFX_SELECT)
	scene_requested.emit(Def.Scenes.SETTINGS)
func _on_quit_pressed() -> void:
	sfx_requested.emit(Def.Const.SFX_SELECT)
	quit_requested.emit()
func _on_yes_pressed() -> void:
	sfx_requested.emit(Def.Const.SFX_SELECT)
	quit_requested.emit()
func _on_no_pressed() -> void:
	sfx_requested.emit(Def.Const.SFX_SELECT)
	toggle_component("pause")

func _on_pause_toggled() -> void:
	toggle_component("pause")
#endregion
