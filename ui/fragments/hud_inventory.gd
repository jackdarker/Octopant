class_name HudInventory extends Control

## a control to display the inventory of the player
@export var character:Character
@export var outfit:bool=false

func _ready()->void:
	pass

func set_character(_character:Character):
	if(character):
		character.inventory.item_added.disconnect(update_list.unbind(1))
		character.inventory.item_removed.disconnect(update_list.unbind(1))	
	character=_character
	if(!outfit):
		character.inventory.item_added.connect(update_list.unbind(1))
		character.inventory.item_removed.connect(update_list.unbind(1))
	update_list()

func _on_visibility_changed() -> void:
	if !%list || !character:
		return
	update_list()

func update_list():
	var list=%list
	for item in list.get_children():
		list.remove_child(item)
		item.queue_free()
	#%lb_desc.text=""	
	%menu.visible=false
	
	if visible:
		var _list
		if(!outfit):
			_list=character.inventory.getItems()
		else:
			_list=character.outfit.getItems()
		for item in _list:
			var _item=ListItem.create_item(item)
			_item.selected.connect(_item_selected)
			list.add_child(_item)		
		
func _item_selected(ID):
	var _item
	if(!outfit):
		_item=character.inventory.getItemByID(ID)
	else:
		_item=character.outfit.getItem(ID)
	#%lb_desc.text=_item.getDescription()
	%menu.clear()
	var _i=1
	%menu.add_item("Cancle")
	for _action in _item.getPossibleActions():
		%menu.add_item(_action.name,_i)
		%menu.set_item_metadata(_i,{"do":doAction.bind(_item,_action.name)})
		_i+=1
		#var _bt=Button.new()
		#_bt.text=_action.name
		#_bt.tooltip_text=_action.description
		#_bt.pressed.connect(doAction.bind(_item,_action.name))
		#%list_actions.add_child(_bt)
	%menu.position=get_global_mouse_position()
	%menu.visible=true

func doAction(_item,_name):
	_item.doAction(_name,self.character)
	update_list()


func _on_menu_index_pressed(index: int) -> void:
	var _data=%menu.get_item_metadata(index)
	if(_data && _data.do):
		_data.do.call()
	pass # Replace with function body.
