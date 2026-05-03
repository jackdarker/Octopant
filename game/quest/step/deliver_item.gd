class_name QuestStepDeliverItems extends QuestStep

## questStep to deliver item from inventory to other character

@export var characterID: String
@export var itemID: String
@export var quantity: int = 1
var gathered: int =0


func ready() -> void:
	super()
	gathered=0
	postLoad()

func stop()->void:
	super()
	Global.main.item_trade.disconnect(_on_item_trade)


func saveData() -> Dictionary:
	var _ret=super()
	_ret["gathered"]=gathered
	return _ret


func postLoad()->void:
	if self.stopped:
		return
	Global.main.item_trade.connect(_on_item_trade)
	meets_condition()

func meets_condition() -> bool:
	var _completed = (gathered >= quantity)
	if _completed && !completed:
		completed=_completed
		updated.emit()
	return completed

func _on_item_trade(giverId:String,receiverId:String,itemid:String,amount:int) -> void:
	if receiverId==characterID and not completed:
		if itemid==itemID:
			gathered += amount
	meets_condition()

func progressText() -> String:
	return str(gathered) +" of " +str(quantity)
