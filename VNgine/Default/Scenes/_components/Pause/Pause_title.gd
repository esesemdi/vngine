extends Control

signal return_requested
signal sfx_requested(sfx_name: StringName)

func _ready() -> void:
	%YesBt.pressed.connect(_on_yes_pressed)
	%NoBt.pressed.connect(_on_no_pressed)

func _on_yes_pressed() -> void:
	sfx_requested.emit(Def.Paths.SFX_SELECT)
	get_tree().quit()

func _on_no_pressed() -> void:
	sfx_requested.emit(Def.Paths.SFX_SELECT)
	return_requested.emit()
