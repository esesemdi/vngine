extends Control

signal quit_confirmed
signal quit_cancelled

func _ready() -> void:
	%YesBt.pressed.connect(_on_yes_pressed)
	%NoBt.pressed.connect(_on_no_pressed)




#region SIGNALS
func _on_yes_pressed() -> void:
	MediaMan.play_sfx(Def.Paths.SFX_SELECT)
	await get_tree().create_timer(0.5).timeout
	quit_confirmed.emit()
func _on_no_pressed() -> void:
	MediaMan.play_sfx(Def.Paths.SFX_SELECT)
	quit_cancelled.emit()
#endregion
