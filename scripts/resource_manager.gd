class_name ResourceManager
extends Node2D

# Variables
var player_list: Array[Player] = []
var build_pipeline: Array[ConstructAreaUnit] = []
var resource_container: Dictionary = {
	"sand": [],
	"water": []
}

# Utility Functions
func is_ready_for_assigning_task() -> bool:
	return build_pipeline.size() > 0

func get_next_resource(build_name: String) -> ConstructAreaUnit:
	#if build_name not in resource_container or resource_container[build_name].size() == 0:
		#return null
	var resource = resource_container[build_name].pop_front()
	if not is_instance_valid(resource):
		resource = null
	return resource

func return_unused_resource(build_name: String, resource: ConstructAreaUnit, remaining_units: float):
	resource.set_extractable_unit(remaining_units)
	resource_container[build_name].push_front(resource)

# Core Functions
func assign_task_to_players():
	if not is_ready_for_assigning_task():
		return
	
	# Process the next construct unit
	var construct_unit: ConstructAreaUnit = build_pipeline.pop_front()
	var build_guide: Array[BuildGuide] = construct_unit.get_build_material_ref_list()
	if build_guide.size() == 0:
		print("No build materials required")
		return

	
	var build: BuildGuide = build_guide.pop_front()
	var required_resource: float = build.resource_required
	print("required_resource 0-", required_resource)
	
	var resource: ConstructAreaUnit = get_next_resource(build.name)
	if resource == null:
		print("No resources available for", build.name)
		build_pipeline.push_front(construct_unit)  # Re-add if resources are unavailable
		return
	
	var resource_unit: float = resource.get_extractable_unit()

	# Assign tasks to players
	for player in player_list:
		if not player.is_available:
			continue
		
		# Calculate the collectable amount
		var collectable_quantity = min(player.collectable_quantity, resource_unit, required_resource)
		player.collect_resource(resource)
		
		# Update remaining resources
		required_resource -= collectable_quantity
		resource_unit -= collectable_quantity
		
		# Update player start position
		player.start_position = construct_unit.mouse_position
		resource.set_extractable_unit(resource_unit)
		print("res assign ", resource_unit)
		
		# Handle resource exhaustion
		if resource_unit == 0 and required_resource > 0:
			print("Resource depleted; fetching new resource")
			resource = get_next_resource(build.name)
			if resource == null:
				break
			resource_unit = resource.get_extractable_unit()
		
		# Exit if all required resources are allocated
		if required_resource == 0:
			break
	
	# Return unused resources to the container
	if resource != null and resource_unit > 0:
		return_unused_resource(build.name, resource, resource_unit)
	
	# Update build guide and pipeline
	print("required_resource ", required_resource)
	if required_resource > 0:
		build.update_resource_required(required_resource)
		build_guide.push_front(build)
		build_pipeline.push_front(construct_unit)
	else:
		print("Task completed for construct unit:", construct_unit)
