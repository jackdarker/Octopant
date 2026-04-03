class_name QuestStepHasFlag extends QuestStep

## questStep that checks on a flag


@export var moduleID: String
@export var flagID: String
@export var valueMin = 0
@export var valueMax = 1


func ready() -> void:
	postLoad()

func postLoad()->void:
	meets_condition()

func meets_condition() -> bool:
	var _x=GR.getModuleFlag(moduleID,flagID)
	if _x && (_x is int || _x is float):
		completed = (_x>=valueMin && _x<=valueMax)
	return completed
