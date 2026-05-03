class_name QuestStepGatherItems extends QuestStep

## questStep to gather item in inventory


@export var itemID: String
@export var quantity: int = 1
var gathered: int


func ready() -> void:
	super()
	gathered=0
	postLoad()

func stop()->void:
	super()
	Global.pc.inventory.item_added.disconnect(_on_item_added)
	Global.pc.inventory.item_removed.disconnect(_on_item_removed)
	
func postLoad()->void:
	if self.stopped:
		return
	Global.pc.inventory.item_added.connect(_on_item_added)
	Global.pc.inventory.item_removed.connect(_on_item_removed)
	gathered = Global.pc.inventory.hasItemID(itemID)
	meets_condition()

func meets_condition() -> bool:
	var _completed = (gathered >= quantity)
	if _completed &&  !completed:
		completed=_completed
		updated.emit()
	return completed

func _on_item_added(gathered_item: String) -> void:
	if gathered_item == itemID and not completed:				#TODO complete doesnt reset if items are removed
		gathered += 1
	meets_condition()

func _on_item_removed(gathered_item: String) -> void:
	if gathered_item == itemID and not completed:
		gathered -= 1
	meets_condition()

func progressText() -> String:
	return str(gathered) +" of " +str(quantity)
