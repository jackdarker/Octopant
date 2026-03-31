class_name QuestSystem extends Node

signal quest_accepted(quest: Quest) # Emitted when a quest gets moved to the ActivePool
signal quest_completed(quest: Quest) # Emitted when a quest gets moved to the CompletedPool
#signal new_available_quest(quest: Quest) # Emitted when a quest gets added to the AvailablePool

#var available: QuestPool = QuestPool.new()			TODO do we need this?
var active: QuestPool = QuestPool.new()
var completed: QuestPool = QuestPool.new()

## Start a given quest, and add it to the active pool
func start_quest(quest: Quest, args: Dictionary = {}) -> Quest:
	assert(quest != null)

	if active.is_quest_inside(quest):
		return quest
	if completed.is_quest_inside(quest): #or QuestSystemSettings.get_config_setting("allow_repeating_completed_quests", false):
		return quest

	#Add the quest to the actives quests
	#available.remove_quest(quest)
	active.add_quest(quest)
	quest_accepted.emit(quest)
	quest.start(args)
	quest.completed.connect(quest_finished.bind(quest))
	return quest

## Complete a given quest, and add it to the completed pool.[br]
## Additionally, if the [objective_completed] property of the quest
##is not set to true when the complete() method gets called,
## it will not mark the quest as completed and instead return back the quest object.[br]
##
## You can ovverride this behavior by setting the "require_objective_completed" in the ProjectSettings to false
func complete_quest(quest: Quest, args: Dictionary = {}) -> Quest:
	if not active.is_quest_inside(quest):
		return quest

	if quest.objective_completed == false: # and QuestSystemSettings.get_config_setting("require_objective_completed"):
		return quest

	quest.complete(args)
	active.remove_quest(quest)
	completed.add_quest(quest)
	quest_completed.emit(quest)

	return quest

## CB for quest signal
func quest_finished(quest: Quest, args: Dictionary = {}):
	if not active.is_quest_inside(quest):
		return quest

	if quest.objective_completed == false: # and QuestSystemSettings.get_config_setting("require_objective_completed"):
		return quest
		
	active.remove_quest(quest)
	completed.add_quest(quest)
	quest_completed.emit(quest)

## Calls the update() method on the given quest
func update_quest(quest: Quest, args: Dictionary = {}) -> Quest:
	var pool_with_quest: QuestPool = null

	for pool in [active,completed]:
		if pool.is_quest_inside(quest):
			pool_with_quest = pool
			break

	if pool_with_quest == null:
		push_warning("Tried calling update on a Quest that is not in any pool.")
		return quest

	quest.update(args)

	return quest


## Marks a given quest as available (Adds it to the available pool)
#func mark_quest_as_available(quest: Quest) -> void:
#	if available.is_quest_inside(quest) or completed.is_quest_inside(quest) or active.is_quest_inside(quest):
#		return
#
#	available.add_quest(quest)
#	new_available_quest.emit(quest)


## Returns all the available quests (quests in the available pool)
#func get_available_quests() -> Array[Quest]:
#	return available.get_all_quests()


## Returns all the active quests (quests in the active pool)
func get_active_quests() -> Array[Quest]:
	return active.get_all_quests()


func get_completed_quests() -> Array[Quest]:
	return completed.get_all_quests()

## Returns true if the given quest is inside the available pool,
## false otherwise
#func is_quest_available(quest: Quest) -> bool:
#	if available.is_quest_inside(quest):
#		return true
#	return false


## Returns true if the given quest is inside the active pool,
## false otherwise
func is_quest_active(quest: Quest) -> bool:
	if active.is_quest_inside(quest):
		return true
	return false


## Returns true if the given quest is inside the completed pool,
## false otherwise
func is_quest_completed(quest: Quest) -> bool:
	if completed.is_quest_inside(quest):
		return true
	return false


func saveData()->Variant:
	var quest_active:Array = []
	var quest_completed:Array = []
	for item in active.get_all_quests():
		quest_active.push_back(item.saveData())
	for item in completed.get_all_quests():
		quest_completed.push_back(item.saveData())	
	return({"quest_active":quest_active,"quest_completed":quest_completed })

## Restores the state of each quest
func loadData(data):
	var _quests: Array[Quest]
	for item in data["quest_active"]:
		var _item=GR.getQuest(item["ID"])
		if !_item:
			Log.printerr("ERROR: quest with the ID "+item["ID"]+" wasn't found")
		else:
			_item.loadData(item)
			active.add_quest(_item)
			_item.completed.connect(quest_finished.bind(_item))
	
	for item in data["quest_completed"]:
		var _item=GR.getQuest(item["ID"])
		if !_item:
			Log.printerr("ERROR: quest with the ID "+item["ID"]+" wasn't found")
		else:
			_item.loadData(item)
			completed.add_quest(_item)
