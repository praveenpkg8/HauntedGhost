class_name ConstructAreaUnit
extends Area2D


var global_day_night_cycle: GlobalDayNightCycle
var global_event_bus: GlobalEventBus
var build_timer: Timer
var sprite_2d: Sprite2D
var second_timer: Timer
var custom_loader_dict: Dictionary
var vector_position: Vector2
var mouse_position: Vector2
#var cons_item: ConstructItem
var cons_unit: ConstructUnit
var is_constructed: bool = false
@export var construct_rect_size = Vector2(64, 64)

signal custom_loader_free(loader_component: Sprite2D)
signal resource_collected(resource)

signal push_for_build_resource(resource, build_material)


func _on_body_entered(body: Player):
	if body.has_method("move_to_position"):
		body.has_resource = true
		emit_signal("resource_collected", self)  # Emit signal with self
		var resoucer_unit = get_extractable_unit()
		if not is_constructed:
			body.is_available = true
		if resoucer_unit == 0:
			queue_free()
		
			
		

func _ready() -> void:
	pass


func init_global_day_night_cycle(_global_day_night_cycle: GlobalDayNightCycle):
	global_day_night_cycle = _global_day_night_cycle
	#_init_build_timer()


func init(
	cons_unit_res: String,
	_mouse_position: Vector2,
	_global_day_night_cycle: GlobalDayNightCycle,
	_global_event_bus: GlobalEventBus,
	_custom_loader_dict: Dictionary
):
	mouse_position = _mouse_position
	sprite_2d = Sprite2D.new()
	connect("body_entered", _on_body_entered)
	cons_unit = load(cons_unit_res).duplicate()
	
	global_day_night_cycle = _global_day_night_cycle
	global_event_bus = _global_event_bus
	#second_timer = global_day_night_cycle.second_timer
	custom_loader_dict = _custom_loader_dict

	var collision_shape: CollisionShape2D = CollisionShape2D.new()
	var rect_shape: RectangleShape2D = RectangleShape2D.new()
	var build_timing: float = cons_unit.build_timing

	

	collision_shape.shape = rect_shape
	sprite_2d.texture = cons_unit.texture
	var texture_size = sprite_2d.texture.get_size()
	#var texture_rect_size = _cons_item.get_size()
	var texture_rect_size = construct_rect_size
	rect_shape.extents = texture_rect_size / 2
	sprite_2d.scale = texture_rect_size / texture_size
	#position = mouse_position

	add_child(sprite_2d)
	add_child(collision_shape)

	_init_build_timer(build_timing)
	#second_timer.connect("timeout", _on_fire_each_sec)
	add_child(build_timer)

	
	
func _call_for_build_resource(build_material) -> void:
	emit_signal("push_for_build_resource", self, build_material)


func _init_build_timer(build_timing=5.0):
	build_timer = Timer.new()
	build_timer.wait_time = build_timing
	build_timer.one_shot = true
	build_timer.autostart = true
	build_timer.connect("timeout", _on_builded)

func get_extractable_resource() -> float:
	return cons_unit.extractable_unit


func get_extractable_unit() -> float:
	return cons_unit.extractable_unit


func set_extractable_unit(modified_value: float):
	cons_unit.extractable_unit = modified_value


func get_build_material_ref_list() -> Array[BuildGuide]:
	var build_material_ref_list: Array = []
	var build_guide: Array[BuildGuide] = cons_unit.build_guide
	return build_guide


func _on_builded() -> void:
	pass
	#var loader_unit = custom_loader_dict["loader_unit"]
	#emit_signal("custom_loader_free", loader_unit)
	#second_timer.disconnect("timeout", _on_fire_each_sec)
	
	
func _on_fire_each_sec() -> void:
	print("calling ")


func _pause_builder_on_night():
	var is_night: GlobalDayNightCycle.cycleType = global_day_night_cycle.get_day_or_night()
	build_timer.set_paused(is_night == GlobalDayNightCycle.cycleType.NIGHT)


func _process(delta: float) -> void:
	#global_day_night_cycle.get_current_date_time()
	#_pause_builder_on_night()
	pass
