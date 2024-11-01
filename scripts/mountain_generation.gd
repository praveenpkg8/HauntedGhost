class_name BorderResource
extends Node2D

@export var radius_x: float = 400.0  # X-axis radius for the ellipse
@export var radius_y: float = 250.0  # Y-axis radius for the ellipse
@export var points_count: int = 100  # Number of points around the ellipse
@export var max_mountain_height: float = 15.0  # Maximum height variation for mountains
@export var flat_probability: float = 0.8  # Probability of plain segments
var global_day_night_cycle: GlobalDayNightCycle
var global_event_bus: GlobalEventBus
const MOUNTAIN_SCENE = preload("res://scenes/mountainScene.tscn")
var LIST_OF_MOUNTAINS: Array[ConstructAreaUnit]
const MOUNTAIN = "res://construct_unit_resources/mountain.tres"

func _ready() -> void:
	pass


func construct_mountain(
	_global_day_night_cycle: GlobalDayNightCycle,
	_global_event_bus: GlobalEventBus
	) -> Array[ConstructAreaUnit]:
	global_day_night_cycle = _global_day_night_cycle
	global_event_bus = _global_event_bus
	position = get_viewport_rect().size / 2  # Center the node on the screen
	print(position)
	LIST_OF_MOUNTAINS.append_array(draw_mountain_ellipse())
	LIST_OF_MOUNTAINS.append_array(draw_mountain_ellipse(1))
	return LIST_OF_MOUNTAINS


func draw_mountain_ellipse(level: int=0) -> Array[ConstructAreaUnit]:
	var list_of_mountain: Array[ConstructAreaUnit] = []
	for i in range(points_count):
		var angle = (PI * 2 * i) / points_count
		var is_plain = randf() < (flat_probability + (level * 0.1))

		# Apply height variation only if it's a mountain point
		var height_variation = 0.0
		var _radius_x = radius_x - (level * 60)
		var _radius_y = radius_y - (level * 40)  # Adjust Y-radius for each level
		
		if not is_plain:
			height_variation = randf() * max_mountain_height - (max_mountain_height / 2)
			var mountain: ConstructAreaUnit = place_mountain_sprite(
				angle, 
				_radius_x + height_variation,
				_radius_y + height_variation
			)
			list_of_mountain.append(mountain)

	return list_of_mountain



func place_mountain_sprite(
	angle: float,
	radius_x: float,
	radius_y: float,
	) -> ConstructAreaUnit:
	# Create the Area2D to act as the parent container
	var area = ConstructAreaUnit.new()
	area.init_global_day_night_cycle(global_day_night_cycle)


	var x = radius_x * cos(angle)
	var y = radius_y * sin(angle)
	var cons_position = Vector2(x, y) + position
	var cons_item: ConstructItem = ConstructItem.new()
	cons_item.init(load(MOUNTAIN), global_event_bus)
	add_child(cons_item)
	add_child(area)
	area.init(
		cons_item,
		cons_position,
		global_day_night_cycle,
		global_event_bus,
		{}
	)
	area.position = cons_position
	print(cons_item.texture != null, area.position)
	

	## Create and configure the Sprite2D
	##var sprite = MOUNTAIN_SCENE.instantiate() as Sprite2D
	#var sprite = Sprite2D.new()
	#sprite.position = Vector2.ZERO  # Position the sprite at the origin of the Area2D
	#area.add_child(sprite)
#
#
	## Create a CollisionShape2D for the Area2D based on the sprite's size
	#var collision_shape = CollisionShape2D.new()
	#var shape = RectangleShape2D.new()
#
	## Calculate the collision shape size based on the sprite's texture size and scale
	  ## Adjust for the sprite's scale
		#
	#var target_size = Vector2(64, 64)
	#sprite.texture = MOUNTAIN.texture
	#var texture_size = sprite.texture.get_size()
	#var scale_factor = target_size / texture_size
	#sprite.scale = scale_factor
#
	#if sprite.texture != null:
		#shape.size = texture_size * sprite.scale
#
	#collision_shape.shape = shape
	#collision_shape.position = Vector2.ZERO
	  ## Align collision shape with the origin of Area2D
#
	#area.add_child(collision_shape)
	#add_child(area)
	return area  # Return the Area2D with the sprite and collision shape inside
