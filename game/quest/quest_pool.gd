class_name QuestPool extends Node

## Collection of quests inside of the pool.
var quests: Array[Quest] = []

## Inserts the given quest inside of the pool.[br]
## By default, the quest is appended to [member quests]
func add_quest(quest: Quest) -> Quest:
	assert(quest != null)
	quests.append(quest)
	return quest


## Removes a quest from the pool.[br]
## By the pool, the quest is removed from [member quests]
func remove_quest(quest: Quest) -> Quest:
	assert(quest != null)
	quests.erase(quest)
	return quest

## Looks up for a quest based on its ID and returns it.[br]
## If no quest is found, [code]null[/code] is returned instead.[br]
## By default, the quest is searched inside of [member quests].
func get_quest_from_id(id: String) -> Quest:
	for quest in quests:
		if quest.ID == id:
			return quest
	return null


## Returns [code]true[/code] if a given quest is inside the pool.
func is_quest_inside(quest: Quest) -> bool:
	return quest in quests


## Returns an Array containing all the IDs of the quests inside of the pool.
func get_ids_from_quests() -> Array[String]:
	var ids: Array[String] = []
	for quest in quests:
		ids.append(quest.ID)
	return ids


## Returns all the quest inside the pool.
func get_all_quests() -> Array[Quest]:
	return quests


## Removes all the pools from the pool.
## By default, it clears the [member quests] array.
func reset() -> void:
	quests.clear()

func update_objective(quest_id: String) -> void:
	var quest: Quest = get_quest_from_id(quest_id)
	quest.update()
