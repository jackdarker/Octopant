extends CanvasLayer

var save_element = preload("res://ui/save_element.tscn")

func _ready() -> void:
	visible = false


func _input(_event):
	if visible!=true:	
		#there are multiple overlays with process="when paused" and even if they are not visible, they would still react to the event
		#f.e. when ready_counter is shown 
		return
	#if event.is_action_released("pause"):
	#	_on_bt_back_pressed()
	#	get_viewport().set_input_as_handled() # stop propagation to level

func _on_bt_focus_entered() -> void:
	#TODO get_node("SoundSelect").playing = true
	pass

func _canSave()->bool:
	return get_parent().canSave()

func _on_visibility_changed() -> void:
	if visible:
		updateSlots()


func updateSlots():
	var _disallowSave=!_canSave()
	
	for item in %lst_saves.get_children():
		%lst_saves.remove_child(item)
		item.queue_free()
		
	var _saves = Global.getAllSaves()
	for item in _saves:
		var _save = save_element.instantiate()
		_save.save_only = false
		_save.can_save=!_disallowSave
		_save.file=item.file
		_save.text=item.info
		_save.filechange.connect(_on_filechange)
		%lst_saves.add_child(_save)
		
	%save_new.file=Global.newSaveFileName()
	%save_new.save_only=true
	%save_new.text="new"
	if(_disallowSave):
		%save_new.visible=false

func _on_bt_back_pressed() -> void:
	visible = false
	get_tree().paused = false


func _on_filechange() -> void:
	updateSlots()
