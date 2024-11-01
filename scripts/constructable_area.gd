class_name ConstructableArea
extends Area2D


var global_event_bus: GlobalEventBus

func _ready() -> void:
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited",  _on_mouse_exited)


func init(_global_event_bus: GlobalEventBus):
	global_event_bus = _global_event_bus


func _on_mouse_entered():
	global_event_bus.emit_signal("is_allowed_to_construct", true)


func _on_mouse_exited():
	global_event_bus.emit_signal("is_allowed_to_construct", false)
	
