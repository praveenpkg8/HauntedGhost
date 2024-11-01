class_name ConstructItem
extends TextureRect

@export var data: ConstructUnit
var global_event_bus: GlobalEventBus


func init(_data: ConstructUnit, _global_event_bus: GlobalEventBus) -> void:
	data = _data
	global_event_bus = _global_event_bus

	

func _ready() -> void:
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	texture = data.texture
	#tooltip_text = "%s\n%s" % [data.name, data.description]
	connect("mouse_entered", _on_item_mouse_entered)
	connect("mouse_exited", _on_item_mouse_exited)

func _on_item_mouse_entered():
	scale = Vector2(1.25, 1.25)

func _on_item_mouse_exited():
	scale = Vector2(1, 1)


func _get_drag_data(at_position: Vector2):
	set_drag_preview(make_drag_preview(at_position))
	return self
	
func make_drag_preview(at_position: Vector2):
	var _text_rect: TextureRect = TextureRect.new()
	_text_rect.texture = texture
	_text_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_text_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_text_rect.custom_minimum_size = size
	_text_rect.modulate.a = 0.5
	_text_rect.position = Vector2(-at_position)
	global_event_bus.emit_signal("componet_dragged", self)

	
	var c: Control = Control.new()
	c.add_child(_text_rect)
	return c
