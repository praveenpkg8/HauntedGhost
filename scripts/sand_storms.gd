class_name SandStrom
extends Node

var areas: Array = []
var screen_size: Vector2
var speed: float = 100.0  # Speed of movement (adjust as needed)
var direction: Vector2
var shake_amount: float = 3.0  # Maximum shake intensity


func _ready() -> void:
	for i in range(12):
		var area_2d = create_areas()
		add_child(area_2d)
		areas.append(area_2d)


func select_random_space() -> int:
	var values = [10, 30, 50]
	var random_index = randi() % values.size()
	return values[random_index]



func create_areas():
	var _area_2d = Area2D.new()
	var collision_shape: CollisionShape2D = CollisionShape2D.new()
	var sprite_2d: Sprite2D = Sprite2D.new()
	var circle_shape: CircleShape2D = CircleShape2D.new()
	screen_size = get_viewport().size

	sprite_2d.texture = load("res://assets/stone.png")
		# Get the size of the texture
	var texture_size = sprite_2d.texture.get_size()
	var scale_factor = Vector2(32.0 / texture_size.x, 32.0 / texture_size.y)

	sprite_2d.scale = scale_factor
	
	circle_shape.radius = 10.0  
	collision_shape.shape = circle_shape
	var random_number_x = randi() % 4 + 1
	var random_number_y = randi() % 4 + 1
	
	var random_x_space = select_random_space()
	var random_y_space = select_random_space()
	
	var sign_x = 1 if randi() % 2 == 0 else -1
	var sign_y = 1 if randi() % 2 == 0 else -1	

	var x_position = random_number_x * sign_x * random_x_space
	var y_position = random_number_y * sign_y * random_y_space
	_area_2d.position = Vector2(
		x_position, y_position
	)
	_area_2d.add_child(sprite_2d)
	_area_2d.add_child(collision_shape)
	direction = (screen_size - _area_2d.position).normalized()
	return _area_2d
	
	


func _process(delta: float) -> void:
	for area_2d in areas:
		var shake = randf_range(-shake_amount, shake_amount)
		var rand_speed = randi() % 4 + 1
		area_2d.position += direction * speed  * delta
		area_2d.position.y += shake 
		

		if area_2d.position.x >= screen_size.x or area_2d.position.y >= screen_size.y:
			area_2d.queue_free()
			areas.erase(area_2d)
