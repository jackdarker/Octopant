extends CanvasLayer

var listening_action: String = ""
var action_buttons := {} # action -> Button node

var msg_scn=ResourceLoader.load("res://ui/message_box.tscn")

func _ready() -> void:
	%bt_reset_shorts.pressed.connect(_on_reset_defaults_pressed)
	visible = false

func _on_visibility_changed() -> void:
	if visible:
		_populate_action_list()

func _on_reset_defaults_pressed() -> void:
	InputMap.load_from_project_settings()
	_populate_action_list()
	_save_bindings()

func _on_rebind_pressed(action: String):
	listening_action = action
	# update UI to show listening state
	var btn = action_buttons.get(action)
	if btn:
		btn.text = "Press a key..."
		btn.grab_focus()

func _unlisten_cancel():
	if listening_action != "":
		var btn = action_buttons.get(listening_action)
		if btn:
			btn.text = _format_bindings_text(listening_action)
	listening_action = ""

func _on_unbind(action:String):
	InputMap.action_erase_events(action)
	if action_buttons.has(action):
		action_buttons[action].text = _format_bindings_text(action)
	_save_bindings()

func _input(event):
	if visible!=true:	
		#there are multiple overlays with process="when paused" and even if they are not visible, they would still react to the event
		#f.e. when ready_counter is shown 
		return
	if listening_action == "":
		return
	# Accept key, mouse button, joy button. Ignore modifier-only events.
	if event is InputEventKey and event.pressed and not event.echo:
		if _is_modifier_only(event):
			return
		_apply_binding(listening_action, event)
		listening_action = ""
		return
	if event is InputEventMouseButton and event.pressed:
		_apply_binding(listening_action, event)
		listening_action = ""
		return
	if event is InputEventJoypadButton and event.pressed:
		_apply_binding(listening_action, event)
		listening_action = ""
		return
	# cancel on Escape
	#if event is InputEventKey and event.pressed and event.scancode == Key.KEY_ESCAPE:
	#	_unlisten_cancel()

func _is_modifier_only(ev: InputEventKey) -> bool:
	return not (ev.keycode != 0 and not ev.is_echo()) and (ev.shift_pressed == false and ev.alt_pressed == false and ev.meta_pressed == false and ev.ctrl_pressed == false)

func _apply_binding(action: String, ev: InputEvent):
	# Check for conflicts: find actions that already use the same event
	var conflict := _find_conflict(action, ev)
	if conflict != "":
		var msg:MessageBox=msg_scn.instantiate()
		msg.text="input already bound to "+conflict+". Unbind first."
		self.add_child(msg)
		return
	if(!Global.Setup.textToEvent(OS.get_keycode_string(ev.keycode))):
		var msg:MessageBox=msg_scn.instantiate()
		msg.text="cannot use this key"
		self.add_child(msg)
		return
	
	# Remove existing bindings for this action (single-bind design). For multi-bind, adjust.
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, ev)
	if action_buttons.has(action):
		action_buttons[action].text = _format_bindings_text(action)
	_save_bindings()


func _find_conflict(action: String, ev: InputEvent) -> String:
	for other in InputMap.get_actions():
		if other == action:
			continue
		var otherEvs=InputMap.action_get_events(other)
		if otherEvs.filter(func(x): return(ev.as_text()==x.as_text())).size()>0:
			return other
	return ""
	
func _populate_action_list():
	Util.delete_children(%lst_shortkeys)
	action_buttons.clear()
	var actions = InputMap.get_actions()
	actions.sort_custom(func(a:String,b:String): return(a<b))
	for action:String in actions:
		if(action.begins_with("ui_")):	#skip builtin actions that we dont use
			continue
		var h = HBoxContainer.new()
		var lbl = Label.new()
		lbl.text = action
		lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h.add_child(lbl)

		var btn = Button.new()
		btn.text = _format_bindings_text(action)
		btn.name = action
		btn.button_up.connect(Callable(self, "_on_rebind_pressed").bind(action))
		h.add_child(btn)
		action_buttons[action] = btn
		btn = Button.new()
		btn.text = "unbind"
		btn.button_up.connect(Callable(self, "_on_unbind").bind(action))
		h.add_child(btn)

		%lst_shortkeys.add_child(h)
		

func _format_bindings_text(action: String) -> String:
	var evs:Array = InputMap.action_get_events(action)
	if evs.size()<=0:
		return "<unassigned>"
	var parts := []
	for e in evs:
		if e is InputEventKey:
			parts.append(OS.get_keycode_string(e.keycode))
		elif e is InputEventMouseButton:
			parts.append("Mouse %d" % e.button_index)
		elif e is InputEventJoypadButton:
			parts.append("Joy %d" % e.button_index)
		else:
			parts.append(str(e))
	return ", ".join(parts)

func _save_bindings():
	Global.saveSettings()


func _on_bt_reset_pressed() -> void:
	Global.Setup.reset()
	Global.saveSettings()
	_on_visibility_changed()

func _on_bt_back_pressed() -> void:
	visible = false
	get_tree().paused = false
