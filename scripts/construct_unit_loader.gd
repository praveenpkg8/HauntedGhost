class_name ConstructUnitLoader
extends Node2D

var contruct_area_2d: ConstructAreaUnit
#var cons_item: ConstructItem
var cons_unit: ConstructUnit
var global_event_bus: GlobalEventBus
var global_day_night_cycle: GlobalDayNightCycle


@onready var loader_unit: Sprite2D = $LoaderUnit
@onready var resource_requirement: Sprite2D = $ResourceRequirement
@onready var custom_loader_dict: Dictionary = {
	"loader_unit": loader_unit,
	"resource_requirement": resource_requirement
}



func _ready() -> void:
	#contruct_area_2d = $ContructArea2D
	#contruct_area_2d.connect("custom_loader_free", _free_custom_loader)
	pass



func init(
		cons_unit_res: String,
		mouse_position: Vector2,
		_global_day_night_cycle: GlobalDayNightCycle,
		_global_event_bus: GlobalEventBus
	):
	#cons_unit = _cons_unit.duplicate()
	contruct_area_2d = ConstructAreaUnit.new().duplicate()
	global_day_night_cycle = _global_day_night_cycle
	global_event_bus = _global_event_bus
	contruct_area_2d.connect("custom_loader_free", _free_custom_loader)
	contruct_area_2d.init(
		cons_unit_res,
		mouse_position,
		global_day_night_cycle,
		global_event_bus,
		custom_loader_dict
	)
	position = mouse_position
	add_child(contruct_area_2d)
	add_to_group("construction_units")


func get_build_material_ref_list() -> Array[BuildGuide]:
	var build_material_ref_list: Array = []
	var build_guide: Array[BuildGuide] = contruct_area_2d.cons_unit.build_guide
	return build_guide
	
func get_extractable_unit() -> float:
	return contruct_area_2d.cons_unit.extractable_unit
	

func set_extractable_unit(modified_value: float):
	contruct_area_2d.cons_unit.extractable_unit = modified_value


func _free_custom_loader(loader_component: Sprite2D) -> void:
	loader_component.queue_free()


func _process(delta: float) -> void:
	pass
