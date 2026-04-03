class_name Quest extends Resource
## Base class for all Quest resources.
##
## By itself it does nothing other than provide a simple API to make quests.[br]
## To make a custom quest make a script that inherits `Quest` and implement your own logic, then create a Resource of the type of your custom quest.

## Unique Identifier of the quest
@export var ID: String
## The name of the quest
@export var quest_name: String
## A brief description of the quest
@export_multiline var quest_description: String
## A brief description that outlines what must be done to complete the quest
@export_multiline var quest_objective: String
## is the quest visible (in Quest-Log & notifications)
@export var hidden:= HIDE.NONE

@export var steps: Array[QuestStep]
@export var rewards: Array

enum HIDE {NONE=0, NAME=1, ALL=255}

## Emitted by default when [method start] gets called.
signal started
## Emitted by default when [method update] gets called.
signal updated
## Emitted by default when [method complete] gets called.
signal completed
## Emitted by default when [objective_completed] gets set.
signal objective_status_updated(value: bool)

signal step_updated(step: QuestStep)

## Whether the objective is fulfilled or not.[br]
## Must be set to true to be able to complete the quest;[br]
## This behaviour can be disabled in [code]ProjectSettings -> QuestSystem -> Config -> Require Objective Completed[/code]
var objective_completed: bool = false:
	set(value):
		objective_completed = value
		objective_status_updated.emit(value)
	get:
		return objective_completed


## Gets called after QuestSystem' [method update_quest] method.[br][br]
##
## By default, it emits the [signal updated] signal.
func update(_args: Dictionary = {}) -> void:
	updated.emit()


## Gets called after QuestSystem' [method start_quest] method.[br]
## Additional data may be passed from the optional [param _args] parameter.[br][br]
##
## By default, it emits the [signal started] signal.
func start(_args: Dictionary = {}) -> void:
	for step: QuestStep in steps:
		step.ready()
		step.updated.connect(_update_step.bind(step))
	started.emit()


## Gets called after QuestSystem' [method complete_quest] method.[br]
## Make sure to set [member objective_completed] to true or disable its requirement in ProjectSettings,[br]
## or this method won't be called.[br][br]
##
## By default, it emits the [signal completed] signal.
func complete(_args: Dictionary = {}) -> void:
	var _complete:=true
	for step in steps:
		if not step.meets_condition():
			_complete=false
	if _complete:
		objective_completed=true
		#if !rewards.is_empty():
		#	for item: Item in rewards:
		#		Globals.inventory.add_item(item, Globals.inventory.get_first_empty_index())
		completed.emit()

func get_quest_step(index: int) -> QuestStep:
	if index > steps.size():
		printerr("Out of bound. Tried to get QuestStep with index %s in an array of size %s" % [index, steps.size()])
	return steps[index]


func complete_step(index: int) -> Error:
	if index > steps.size():
		printerr("Out of bound. Tried to complete QuestStep with index %s in an array of size %s" % [index, steps.size()])
		return ERR_DOES_NOT_EXIST
	steps[index].completed = true
	complete()
	return OK

func get_first_uncompleted_step() -> QuestStep:
	var uncompleted_steps := steps.filter(func(step): return step.completed == false)
	if uncompleted_steps.is_empty(): return null
	return uncompleted_steps[0]

func _update_step(step: QuestStep) -> void:
	step_updated.emit(step)
	complete()


func saveData()->Variant:
	var stepData={}
	var _i:int=0
	for step in steps:
		stepData[_i]=step.saveData()
		_i+=1
	var data ={"ID":ID,
			"complete":objective_completed,
			"hidden": hidden,
			"steps":stepData}
	return(data)

func loadData(data:Dictionary):
	objective_completed=data["complete"]
	hidden = data["hidden"]
	var _i:int=0
	for step in steps:
		step.loadData(data["steps"][str(_i)])	#TODO things get messed up if steps are shuffled in new versions
		_i+=1
		step.updated.connect(_update_step.bind(step))


func _to_string() -> String:
	return "<Quest id=" + ID + " name=\"" + quest_name + "\">"
