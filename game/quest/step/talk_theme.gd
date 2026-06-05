class_name QuestStepTalkTheme extends QuestStep

## questStep to talk with an NPC about something
## if you talked ybout it before the step was active you have to talk again !

@export var npcID: String
@export var themeID: String

func ready() -> void:
	super()
	postLoad()

func stop()->void:
	super()
	Global.npc_talked.disconnect(_on_talk)
	
func postLoad()->void:
	if self.stopped:
		return
	Global.npc_talked.connect(_on_talk)
	meets_condition()

func meets_condition() -> bool:
	return completed

func _on_talk(_npcID:String,_themeID:String) -> void:
	if _npcID == npcID and themeID==_themeID and not completed:
		completed=true
		updated.emit()
	meets_condition()

func progressText() -> String:
	return "talked about it"
