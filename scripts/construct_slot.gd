class_name ConstructSlot
extends PanelContainer


@export var type: ConstructUnit.Type


func init(typo: ConstructUnit.Type, cms: Vector2) -> void:
	type = typo
	custom_minimum_size = cms
	
	
	
