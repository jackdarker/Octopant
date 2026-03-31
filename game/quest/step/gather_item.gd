class_name GatherItemsQuestStep extends QuestStep

## questStep to gather item in inventory


@export var itemID: String
@export var quantity: int = 1
var gathered: int


func ready() -> void:
	postLoad()

func postLoad()->void:
	Global.pc.inventory.item_added.connect(_on_item_added)
	Global.pc.inventory.item_removed.connect(_on_item_removed)
	gathered = Global.pc.inventory.hasItemID(itemID)
	meets_condition()

func meets_condition() -> bool:
	completed = (gathered >= quantity)
	return completed

func _on_item_added(gathered_item: String) -> void:
	if gathered_item == itemID and not completed:				#TODO complete doesnt reset if items are removed
		gathered += 1
		updated.emit()
	meets_condition()

func _on_item_removed(gathered_item: String) -> void:
	if gathered_item == itemID and not completed:
		gathered -= 1
		updated.emit()
	meets_condition()
