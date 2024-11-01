extends Node2D

var GUI: CanvasLayer
var constructable_area: ConstructableArea
var global_event_bus: GlobalEventBus
var is_dragged: bool = false
var is_allowed_to_build: bool = false
var element: String
var _cons_item: ConstructItem
var global_day_night_cycle: GlobalDayNightCycle
const CONSTRUCT_UNIT_LOADER = preload("res://scenes/construct_unit_loader.tscn")
var build_pipeline: Array = []
var collected_resource: Dictionary = {}

@onready var player: CharacterBody2D = $player
var resource_manager: ResourceManager
var border_resource: BorderResource

const MOUNTAIN_SCENE = preload("res://scenes/mountainScene.tscn")
var resource_container = {
	"sand": [],
	"water": []
}


func _ready() -> void:
	global_event_bus = GlobalEventBus.new()
	GUI = $GUI
	global_day_night_cycle = $DayNightCycle
	GUI.init(global_event_bus)
	
	constructable_area = $ConstructableArea
	constructable_area.init(global_event_bus)

	global_event_bus.connect("componet_dragged", _print_component_dragged)
	global_event_bus.connect("is_allowed_to_construct", _check_is_allowed_to_build)
	
	resource_manager = ResourceManager.new()
	#add_child(resource_manager)
	border_resource = BorderResource.new()
	add_child(border_resource)
	var resource_pool = border_resource.construct_mountain(
		global_day_night_cycle,
		global_event_bus
		)
	for _res in resource_pool:
		add_child(_res)
		resource_container["sand"].append(_res)


func _process(delta: float) -> void:
	var mouse_position = get_local_mouse_position()
	if (
		Input.is_action_just_released("left_click") 
		and is_dragged 
		and is_allowed_to_build
	):
		populate_construction_site(mouse_position)
		is_dragged = false
		_cons_item = null

	var cons_build_guide: ConstructUnitLoader = get_construct_build_pipeline()
	construct_build_item(cons_build_guide)
	if cons_build_guide:
		print("cons_build_guide ", cons_build_guide)


func _check_is_allowed_to_build(_is_allowed_to_build: bool):
	is_allowed_to_build = _is_allowed_to_build


func populate_construction_site(mouse_position: Vector2):
	
	if is_position_occupied(mouse_position):
		return  # Stop if the position is already occupied
		
	var construct_unit_loader: ConstructUnitLoader = CONSTRUCT_UNIT_LOADER.instantiate()
	add_child(construct_unit_loader)
	construct_unit_loader.init(
		_cons_item,
		mouse_position,
		global_day_night_cycle,
		global_event_bus
	)
	build_pipeline.append(construct_unit_loader)
	for _build in build_pipeline:
		var build_guide = _build.cons_item.data.build_guide
		for build_material in build_guide:
			for i in range(build_guide[build_material]):
				print("buidAmount ", build_guide[build_material])
				var _res = resource_container[build_material].pop_front()
				
				resource_manager.init(
					player,
					_res,
					mouse_position
				)
 

func construct_build_item(unit_loader: ConstructUnitLoader):
	pass


func is_position_occupied(position: Vector2) -> bool:
	var areas = get_tree().get_nodes_in_group("construction_units")
	for area in areas:
		if area.position.distance_to(position) < 64.0:
			return true  # Position is occupied
	return false


func get_construct_build_pipeline() -> ConstructUnitLoader:
	if build_pipeline.size() == 0:
		return null
	var unit_loader: ConstructUnitLoader = build_pipeline.pop_front()
	return unit_loader

func _print_component_dragged(cons_item: TextureRect):
	_cons_item = cons_item
	element = "home"
	is_dragged = true
	
