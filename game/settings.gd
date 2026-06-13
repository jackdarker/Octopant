class_name Settings extends RefCounted


func _ready()->void:
	pass
	
func reset()->void:
	InputMap.load_from_project_settings()
	pass

## returns "" if action unknown or has no event bound
func getKeyForAction(action:String)->String:
	var _act=InputMap.action_get_events(action)[0]
	if(_act && _act is InputEventKey):
		return((_act as InputEventKey).as_text_keycode())
	return ""
	
## stores key-binds in json 
func saveInputMap()->Variant:
	var data={}
	for action:String in InputMap.get_actions():
		data[action]=""  #for unbound actions
		for evt in InputMap.action_get_events(action):
			if(evt is InputEventKey):
				var evt2= evt as InputEventKey
				data[action]=evt2.as_text_keycode()
	return data

func loadInputMap(data:Dictionary):
	var _keymaps={}
	for action in InputMap.get_actions():
		if InputMap.action_get_events(action).size() != 0:
			_keymaps[action] = InputMap.action_get_events(action)[0]	#TODO multiple binds?

	for action in _keymaps.keys():
		if data.has(action):
			if(data[action]==""):	#unbind action
				InputMap.action_erase_events(action)
				break
			var evt=textToEvent(data[action])
			if(evt):
				_keymaps[action] = evt
				InputMap.action_erase_events(action)
				InputMap.action_add_event(action, _keymaps[action])
			else:
				Log.error("unknown eventbind "+data[action])

## this converts the savefile textvalue to event
func textToEvent(text:String)->InputEvent:
	var evt=null
	var _i 
	_i=["0","1","2","3","4","5","6","7","8","9"].find(text)
	if(_i>=0):
		evt=InputEventKey.new()
		evt.keycode=Key.KEY_0+_i
		return evt
	_i=["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"].find(text)
	if(_i>=0):
		evt=InputEventKey.new()
		evt.keycode=Key.KEY_A+_i
		return evt
	return evt

func saveData()->Variant:
	var data:Dictionary ={	}
	data["keys"]=saveInputMap()
	return data
	
func loadData(data):
	if(data.has("keys")):
		loadInputMap(data["keys"])
	pass
