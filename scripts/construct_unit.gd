class_name ConstructUnit
extends Resource

enum Type {basic, middle, advance}

@export var type: Type
@export var name: String
@export var description: String
@export var texture: Texture2D
@export var build_timing: float = 5.0

@export var build_guide: Dictionary = {}
