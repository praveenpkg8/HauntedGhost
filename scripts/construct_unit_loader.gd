class_name ConstructUnitLoader
extends Node2D

var contruct_area_2d: ConstructAreaUnit
var cons_item: ConstructItem
var global_event_bus: GlobalEventBus
var global_day_night_cycle: GlobalDayNightCycle


@onready var loader_unit: Sprite2D = $LoaderUnit
@onready var resource_requirement: Sprite2D = $ResourceRequirement
@onready var custom_loader_dict: Dictionary = {
	"loader_unit": loader_unit,
	"resource_requirement": resource_requirement
}



func _ready() -> void:
	contruct_area_2d = $ContructArea2D
	contruct_area_2d.connect("custom_loader_free", _free_custom_loader)



func init(
		_cons_item: ConstructItem,
		mouse_position: Vector2,
		_global_day_night_cycle: GlobalDayNightCycle,
		_global_event_bus: GlobalEventBus
	):
	cons_item = _cons_item
	global_day_night_cycle = _global_day_night_cycle
	global_event_bus = _global_event_bus
	contruct_area_2d.init(
		_cons_item,
		mouse_position,
		global_day_night_cycle,
		global_event_bus,
		custom_loader_dict
	)
	position = mouse_position
	add_to_group("construction_units")


func _free_custom_loader(loader_component: Sprite2D) -> void:
	loader_component.queue_free()


func _process(delta: float) -> void:
	pass
