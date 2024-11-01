class_name ResourceManager
extends Node2D

var player: CharacterBody2D
var resource: ConstructAreaUnit
var res_position: Vector2

func init(
	_player: CharacterBody2D,
	resource: ConstructAreaUnit,
	_res_position: Vector2
	):
	res_position = _res_position
	player = _player
	player.move_to_position(resource.position)

	if resource != null:
		if not resource.is_connected("resource_collected", _on_resource_collected):
			var is_connected = resource.connect("resource_collected", _on_resource_collected)
			print("Signal connected--:", is_connected) 


func _on_resource_collected(resource):
	print("Resource collected from:", resource)
	resource.queue_free()
	player.move_to_position(res_position)
