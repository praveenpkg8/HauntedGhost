extends CharacterBody2D

@export var speed: float = 200
@onready var start_position = position  # Save starting position

var has_resource: bool = false
var target_position: Vector2

func _ready():
	# Initialize the target to a neutral value (starting point)
	print("start_position ", start_position)
	target_position = start_position

func _physics_process(delta: float):
	if position.distance_to(target_position) > 2:
		var direction = (target_position - position).normalized()
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO  # Stop when near target

	move_and_slide()

func move_to_position(target: Vector2):
	target_position = target
	print("target_position", target_position)
