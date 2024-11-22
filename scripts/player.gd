class_name  Player
extends CharacterBody2D

@export var speed: float = 200
@onready var start_position = position  # Save starting position
@export var collectable_quantity: float = 2

var has_resource: bool = false
var target_position: Vector2
var is_available: bool = true
var is_collected: bool = false

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


func collect_resource(resource: ConstructAreaUnit):
	# Player should move to resource position 
	# While haveing resource player should check for extractable resource 
	# If extractable resource got completed  emiting for queue free or thresource
	# After collecting make the player to move to construction resource
	var target: Vector2 = resource.position
	assign_signal_to_resource_collected(resource)
	move_to_position(target)
	is_available = false


func assign_signal_to_resource_collected(resource):
	if resource != null:
		if not resource.is_connected("resource_collected", _on_resource_collected):
			var is_connected = resource.connect("resource_collected", _on_resource_collected)
			print("Signal connected--:") 


func _on_resource_collected(resource):
	#resource.queue_free()
	move_to_position(start_position)
