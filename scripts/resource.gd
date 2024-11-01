class_name ResourceItem
extends Area2D

signal resource_collected(resource)

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.has_method("move_to_position"):
		body.has_resource = true
		print("Emitting signal from:", self.name)
		emit_signal("resource_collected", self)  # Emit signal with self
		
