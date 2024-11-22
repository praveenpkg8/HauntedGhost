extends CanvasLayer


var cons_resource_size: int = 8
var ConsResource: GridContainer
var ConstructLoadUnits: Array[String] = [
	"res://construct_unit_resources/house.tres",
	"res://construct_unit_resources/water.tres"
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ConsResource = $ConsResource
	
	
		
func init(global_event_bus: GlobalEventBus):
	for i in cons_resource_size:
		var slot: ConstructSlot = ConstructSlot.new()
		slot.init(
			ConstructUnit.Type.basic,
			Vector2(64, 64)
		)
		ConsResource.add_child((slot))


	for i in ConstructLoadUnits.size():
		var cons_item: ConstructItem = ConstructItem.new()
		cons_item.init(ConstructLoadUnits[i], global_event_bus)
		print(cons_item.data.name)
		ConsResource.get_child(i).add_child(cons_item)





func _process(delta: float) -> void:
	pass
