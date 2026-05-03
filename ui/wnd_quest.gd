extends CanvasLayer

func _ready() -> void:
	visible = false

func _on_visibility_changed() -> void:
	if visible:
		updateQuests()

func _on_bt_back_pressed() -> void:
	visible = false
	get_tree().paused = false

func updateQuests():
	for item in %lst_active.get_children():
		%lst_active.remove_child(item)
		item.queue_free()
	for item in %lst_complete.get_children():
		%lst_complete.remove_child(item)
		item.queue_free()
	%lbl_questdesc.text=""
	
	var bt:Button
	for item in Global.QS.get_active_quests():
		if item.hidden == Quest.HIDE.NONE:
			bt=Button.new()
			bt.text=item.quest_name
			bt.pressed.connect(viewQuest.bind(item.ID))
			%lst_active.add_child(bt)
	for item in Global.QS.get_completed_quests():
		bt=Button.new()
		bt.text=item.quest_name
		bt.pressed.connect(viewQuest.bind(item.ID))
		%lst_complete.add_child(bt)

func viewQuest(ID:String):
	var quest:=Global.QS.active.get_quest_from_id(ID)
	if !quest:
		quest=Global.QS.completed.get_quest_from_id(ID)
	var text=quest.quest_description + ("\n COMPLETE" if quest.objective_completed else "")
	for step in quest.steps:
		var _progress=step.progressText()
		text+="\n" #String.chr(13)+String.chr(10)
		text+= "X " if step.completed else "O "
		text+=step.title if (step.hidden==Quest.HIDE.NONE || step.completed) else "???"
		text+=("\n\t"+_progress) if (_progress!="" && (step.hidden==Quest.HIDE.NONE || step.completed)) else "" 	
	%lbl_questdesc.text=text
