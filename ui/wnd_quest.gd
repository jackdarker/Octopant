extends CanvasLayer

var checkTextScene = preload("res://ui/fragments/check_text.tscn")

func _ready() -> void:
	visible = false

func _on_visibility_changed() -> void:
	if visible:
		updateQuests()
		updateTutorials()
		Tutorials.tutorial_trigger.emit("basic_log")

func _on_bt_back_pressed() -> void:
	visible = false
	get_tree().paused = false

func updateQuests():
	clearQuestSteps()
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
	clearQuestSteps()
	for step in quest.steps:
		var _progress=step.progressText()
		var bullet=checkTextScene.instantiate()
		%queststeps.add_child(bullet)
		bullet.state.texture=load("res://assets/images/icons/ic_checked.svg") if step.completed else load("res://assets/images/icons/ic_unchecked.svg")
		bullet.label.text=step.title if (step.hidden==Quest.HIDE.NONE || step.completed) else "???"
		bullet.label.text+=("\n\t"+_progress) if (_progress!="" && (step.hidden==Quest.HIDE.NONE || step.completed)) else ""
		bullet.focus_entered.connect(_on_queststep_input.bind(step))
	%lbl_questdesc.text=text

func clearQuestSteps():
	Util.delete_children(%queststeps)

func _on_queststep_input(step:QuestStep) -> void:
	%lbl_questdesc.text=step.hint

func updateTutorials():
	for item in %lst_tutorials.get_children():
		%lst_tutorials.remove_child(item)
		item.queue_free()
	%lbl_tutorial.text=""
	
	var bt:Button
	var _items=Tutorials.shown.keys()
	_items.sort()
	for item in Tutorials.shown.keys():
		if Tutorials.shown[item]:
			#var data:=Tutorials.get_tutorial_data(item)
			bt=Button.new()
			bt.text=item
			bt.pressed.connect(Tutorials.show.bind(item,true))	#TODO its possible to press multiple buttons which will queue the popups
			%lst_tutorials.add_child(bt)
