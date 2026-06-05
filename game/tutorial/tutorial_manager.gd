class_name TutorialManager extends Node

# add to autoload!

# Signals
signal tutorial_trigger(id: String) #call this to trigger tutorial instead of using show()
signal tutorial_shown(id: String)	#called when showing
signal tutorial_closed(id: String)

@export var popup_scene: PackedScene = preload("res://ui/tutorial_popup.tscn")
@export var max_queue_items: int = 5

# State
var shown: Dictionary = {}        # id -> true
var current_popup = null
var queue := []                  # Array of tutorial IDs or Dictionaries

func _ready() -> void:
	tutorial_trigger.connect(show)
	pass

# Show API (immediate or queued)
func show(id: String, force: bool = false) -> void:
	var data:= get_tutorial_data(id)
	if !data:
		return
	if data.show_once and shown.get(id, false) and not force:
		return
	# If a popup is active, queue it (preserve order)
	var item := {"id": id, "data": data, "force": force}
	if current_popup:
		if queue.size() < max_queue_items:
			queue.append(item)
		return
	_present(item)

func _present(item: Dictionary) -> void:
	current_popup = popup_scene.instantiate()
	add_child(current_popup)
	#current_popup.set_anchors_preset(Control.LayoutPreset.PRESET_FULL_RECT)
	# Setup content and options
	current_popup.call_deferred("setup_from_dict", item.data)
	# Anchoring: handled by popup itself
	#current_popup.popup_centered_clamped()
	shown[item.id] = true
	tutorial_shown.emit(item.id)
	current_popup.closed.connect(_on_popup_closed.bind(item.id))

func _on_popup_closed(id: String) -> void:
	#save_shown_to_save()
	if current_popup:
		current_popup.queue_free()
		current_popup = null
	tutorial_closed.emit( id)
	# Present next queued
	if queue.size() > 0:
		var next = queue.pop_front()
		_present(next)

# Utility: reset shown flags (for debug / replay)
func reset_all_shown() -> void:
	shown = {}

func get_tutorial_data(id:String)->TutorialData:
	return GR.getTutorial(id)
 
# Query
func has_shown(id: String) -> bool:
	return shown.get(id, false)

func loadData(data):
	var _shown=data["shown"]
	for id in _shown:
		self.shown[id]=true
			
func saveData()->Variant:
	var _shown:Array=self.shown.keys().filter(func(x):return self.shown[x])
	return({"shown":_shown})
