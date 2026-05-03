class_name QuestStep extends Resource

@export_multiline var title: String
@export var completed: bool = false
@export var hidden:=Quest.HIDE.NONE
var index:int=0	# assigned when starting quest
var stopped:bool=false

signal updated

## Virtual method, this has to be overriden
func meets_condition() -> bool:
	return completed

# override this also see postLoad
func ready() -> void:
	stopped=false
	completed=false

func stop()->void:
	var _conns=updated.get_connections()
	for _conn in _conns:
		updated.disconnect(_conn.callable)
	stopped=true
	
func saveData() -> Dictionary:
	return {"completed": completed, "hidden":hidden, "index":index, "stopped":stopped}


func loadData(data: Dictionary) -> void:
	for key in data.keys():
		set(key, data[key])
	postLoad()

# override this and reconnect signal-handlers 
func postLoad():
	pass

## override to return a text for the Quest-Viewer to give a hint how much of the step is done
func progressText() -> String:
	return ""
