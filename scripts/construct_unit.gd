class_name ConstructUnit
extends Resource

enum Type {basic, middle, advance}

class buildGuide:
	var resource_name: String
	var require_resource: float
	

@export var type: Type
@export var name: String
@export var description: String
@export var texture: Texture2D
@export var build_timing: float = 5.0
@export var extractable_unit: float = 0.0

@export var build_guide: Array[BuildGuide]
