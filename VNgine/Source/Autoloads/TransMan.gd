extends Node

# Simple transition singleton
# Add to Project > Project Settings > Autoload as "Tran"

var _overlay: ColorRect
var _tween: Tween

func _ready() -> void:
	# Create fullscreen overlay for scene transitions
	_overlay = ColorRect.new()
	_overlay.color = Color.BLACK
	_overlay.color.a = 0.0
	_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_overlay.z_index = 256
	add_child(_overlay)

# Fade a Node2D or Control in/out
# Auto-detects visibility and chooses appropriate transition
func node(target: CanvasItem, type: String = "auto", duration: float = 0.3) -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	
	# Auto-detect based on visibility
	if type == "auto":
		type = "fade_out" if target.visible else "fade_in"
	
	var start_alpha: float
	var end_alpha: float
	
	if type == "fade_in":
		start_alpha = 0.0
		end_alpha = 1.0
		target.visible = true
		target.modulate.a = start_alpha
		_tween.tween_property(target, "modulate:a", end_alpha, duration)
	else: # fade_out
		start_alpha = 1.0
		end_alpha = 0.0
		target.modulate.a = start_alpha
		_tween.tween_property(target, "modulate:a", end_alpha, duration)
		_tween.tween_callback(func(): target.visible = false)

# Fade scene to/from black
func scene(type: String = "fade_in", duration: float = 0.3) -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	
	var start_alpha: float
	var end_alpha: float
	
	if type == "fade_in": # Scene fading IN means overlay fading OUT
		start_alpha = 1.0
		end_alpha = 0.0
	else: # fade_out - Scene fading OUT means overlay fading IN
		start_alpha = 0.0
		end_alpha = 1.0
	
	_overlay.color.a = start_alpha
	_tween.tween_property(_overlay, "color:a", end_alpha, duration)

# Await-friendly versions
func node_async(target: CanvasItem, type: String = "auto", duration: float = 0.3) -> void:
	node(target, type, duration)
	await _tween.finished

func scene_async(type: String = "fade_in", duration: float = 0.3) -> void:
	scene(type, duration)
	await _tween.finished
