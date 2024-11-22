class_name BuildGuide
extends Resource

@export var name: String
@export var resource_required: float

func update_resource_required(modified_resource: float):
	resource_required = modified_resource
