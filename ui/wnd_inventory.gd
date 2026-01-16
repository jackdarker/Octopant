extends CanvasLayer

@export var character:Character

func _ready() -> void:
	visible=false

func _on_visibility_changed() -> void:
	if !%list:
		return
	update_list()

func update_list():
	var list=%list
	for item in list.get_children():
		list.remove_child(item)
		item.queue_free()
		
	for item in %list_actions.get_children():
		%list_actions.remove_child(item)
		item.queue_free()
		
	if visible:
		for item in character.inventory.getItems():
			var _item=ListItem.create_item(item)
			_item.selected.connect(_item_selected)
			list.add_child(_item)		
		
func _item_selected(id):
	var _item=character.inventory.getItemByID(id)
	%lb_desc.text=_item.getDescription()
	for item in %list_actions.get_children():
		%list_actions.remove_child(item)
		item.queue_free()
	
	for _action in _item.getPossibleActions():
		var _bt=Button.new()
		_bt.text=_action.name
		_bt.tooltip_text=_action.description
		_bt.pressed.connect(doAction.bind(_item,_action.name))
		%list_actions.add_child(_bt)

func doAction(_item,_name):
	_item.doAction(_name,self.character)
	update_list()
	
	
func _on_bt_back_pressed() -> void:
	visible = false
	get_tree().paused = false
