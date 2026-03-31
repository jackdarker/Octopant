class_name QuestStep extends Resource

@export_multiline var title: String
@export var completed: bool = false

signal updated

## Virtual method, this has to be overriden
func meets_condition() -> bool:
	return completed

# override this also see postLoad
func ready() -> void:
	pass


func saveData() -> Dictionary:
	return {"completed": completed}


func loadData(data: Dictionary) -> void:
	for key in data.keys():
		set(key, data[key])
	postLoad()

# override this and reconnect signal-handlers 
func postLoad():
	pass
