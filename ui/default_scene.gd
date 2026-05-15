class_name DefaultScene extends Control

var sceneID: String = "UNREGISTERED_SCENE"
var uniqueSceneID: int = -1
var parentSceneUniqueID: int = -1

#TODO
func react_scene_end(_savedTag, _args):
	pass

## override this with false if player should not be able to save 
func canSave()->bool:
	return true

func saveData()->Dictionary:
	return {"parentUID":parentSceneUniqueID,
		"UID":uniqueSceneID}
	
func loadData(data):
	parentSceneUniqueID=data["parentUID"]
	uniqueSceneID=data["UID"]
