class_name QuestStepKillMob extends QuestStep

## questStep to kill a certain mob-type


@export var mobID: String
@export var quantity: int = 1
var killed: int

func ready() -> void:
	super()
	killed=0
	postLoad()

func stop()->void:
	super()
	Global.npc_defeated.disconnect(_on_kill)
	
func postLoad()->void:
	if self.stopped:
		return
	Global.npc_defeated.connect(_on_kill)
	meets_condition()

func meets_condition() -> bool:
	var _completed = (killed >= quantity)
	if _completed &&  !completed:
		completed=_completed
		updated.emit()
	return completed

func _on_kill(npc:Character) -> void:
	if npc.ID == mobID and not completed:
		killed += 1
	meets_condition()

func progressText() -> String:
	return str(killed) +" of " +str(quantity)

func saveData() -> Dictionary:
	var data=super()
	data["killed"]=killed
	return data
