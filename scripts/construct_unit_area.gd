class_name ConstructAreaUnit
extends Area2D


var global_day_night_cycle: GlobalDayNightCycle
var global_event_bus: GlobalEventBus
var build_timer: Timer
var sprite_2d: Sprite2D
var second_timer: Timer
var custom_loader_dict: Dictionary
var vector_position: Vector2

signal custom_loader_free(loader_component: Sprite2D)
signal resource_collected(resource)

signal push_for_build_resource(resource, build_material)


func _on_body_entered(body):
	if body.has_method("move_to_position"):
		body.has_resource = true
		print("Emitting signal from:", self.name)
		emit_signal("resource_collected", self)  # Emit signal with self
		

func _ready() -> void:
	sprite_2d = $Sprite2D
	connect("body_entered", _on_body_entered)


func init_global_day_night_cycle(_global_day_night_cycle: GlobalDayNightCycle):
	global_day_night_cycle = _global_day_night_cycle
	#_init_build_timer()


func init(
	_cons_item: ConstructItem,
	mouse_position: Vector2,
	_global_day_night_cycle: GlobalDayNightCycle,
	_global_event_bus: GlobalEventBus,
	_custom_loader_dict: Dictionary
):
	sprite_2d = Sprite2D.new()
	#sprite_2d = $Sprite2D
	
	global_day_night_cycle = _global_day_night_cycle
	global_event_bus = _global_event_bus
	second_timer = global_day_night_cycle.second_timer
	var build_guide = _cons_item.data.build_guide
	custom_loader_dict = _custom_loader_dict

	var collision_shape: CollisionShape2D = CollisionShape2D.new()
	var rect_shape: RectangleShape2D = RectangleShape2D.new()
	var build_timing: float = _cons_item.data.build_timing

	var texture_rect_size = _cons_item.get_size()
	rect_shape.extents = texture_rect_size / 2

	collision_shape.shape = rect_shape
	sprite_2d.texture = _cons_item.texture
	var texture_size = sprite_2d.texture.get_size()
	sprite_2d.scale = texture_rect_size / texture_size

	add_child(sprite_2d)
	add_child(collision_shape)

	_init_build_timer(build_timing)
	second_timer.connect("timeout", _on_fire_each_sec)
	add_child(build_timer)

	
	
func _call_for_build_resource(build_material) -> void:
	emit_signal("push_for_build_resource", self, build_material)


func _init_build_timer(build_timing=5.0):
	build_timer = Timer.new()
	build_timer.wait_time = build_timing
	build_timer.one_shot = true
	build_timer.autostart = true
	build_timer.connect("timeout", _on_builded)


func _on_builded() -> void:
	pass
	#var loader_unit = custom_loader_dict["loader_unit"]
	#emit_signal("custom_loader_free", loader_unit)
	#second_timer.disconnect("timeout", _on_fire_each_sec)
	
	
func _on_fire_each_sec(build_guide: Dictionary) -> void:
	print("calling ", build_guide)
	for key in build_guide.keys():
		for i in range(build_guide[key]):
			global_event_bus.emit_signal("push_for_building", build_guide[key])


func _pause_builder_on_night():
	var is_night: GlobalDayNightCycle.cycleType = global_day_night_cycle.get_day_or_night()
	build_timer.set_paused(is_night == GlobalDayNightCycle.cycleType.NIGHT)


func _process(delta: float) -> void:
	global_day_night_cycle.get_current_date_time()
	_pause_builder_on_night()
