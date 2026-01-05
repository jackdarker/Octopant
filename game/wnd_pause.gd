extends CanvasLayer

func _ready() -> void:
	visible = false
	%bt_save_slot_1.pressed.connect(save.bind(1))
	%bt_load_slot_1.pressed.connect(load.bind(1))
	%bt_save_slot_2.pressed.connect(save.bind(2))
	%bt_load_slot_2.pressed.connect(load.bind(2))
	%bt_save_slot_3.pressed.connect(save.bind(3))
	%bt_load_slot_3.pressed.connect(load.bind(3))

func _input(event):
	if visible!=true:	
		#there are multiple overlays with process="when paused" and even if they are not visible, they would still react to the event
		#f.e. when ready_counter is shown 
		return
	#if event.is_action_released("pause"):
	#	_on_bt_back_pressed()
	#	get_viewport().set_input_as_handled() # stop propagation to level

func _on_bt_focus_entered() -> void:
	#get_node("SoundSelect").playing = true
	pass

func _canSave()->bool:
	return get_parent().canSave()

func _on_visibility_changed() -> void:
	if visible:
		var _disallowSave=!_canSave()
		%bt_save_slot_1.disabled=_disallowSave
		%bt_load_slot_1.disabled=false
		%bt_save_slot_2.disabled=_disallowSave
		%bt_load_slot_2.disabled=false
		%bt_save_slot_3.disabled=_disallowSave
		%bt_load_slot_3.disabled=false
		

func _on_bt_back_pressed() -> void:
	visible = false
	get_tree().paused = false


func save(slot) -> void:
	Global.saveToFile(slot)

func load(slot)->void:
	Global.loadFromFile(slot)
