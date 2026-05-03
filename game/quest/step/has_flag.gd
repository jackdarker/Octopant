class_name QuestStepHasFlag extends QuestStep

## questStep that checks on a flag


@export var moduleID: String
@export var flagID: String
@export var valueMin = 0
@export var valueMax = 1


func ready() -> void:
	super()
	postLoad()

func stop()-> void:
	super()
	GR.moduleFlagChanged.disconnect(_on_flag_change)

func postLoad()->void:
	if self.stopped:
		return
	GR.moduleFlagChanged.connect(_on_flag_change)
	meets_condition()

func meets_condition() -> bool:
	var _x=GR.getModuleFlag(moduleID,flagID)
	if _x && (_x is int || _x is float):
		var _completed = (_x>=valueMin && _x<=valueMax)
		if _completed &&  !completed:
			completed=_completed
			updated.emit()
	return completed

func _on_flag_change(module:String, flag:String, newvalue:Variant):
	if(module==moduleID && flag==flagID && !completed):
		meets_condition()

func progressText() -> String:
	return ""	#TODO 
