extends CanvasLayer

@export var character:Character
@export var craftStation:String="Backpack"

func _ready() -> void:
	visible=false

func _on_visibility_changed() -> void:
	if !%list:
		return
	$PanelContainer/VBoxContainer/Label.text="Crafting - "+craftStation
	update_list()

func update_list():
	var list=%list
	for item in list.get_children():
		list.remove_child(item)
		item.queue_free()
	%lb_desc.text=""
	for item in %list_actions.get_children():
		%list_actions.remove_child(item)
		item.queue_free()
		
	if visible:
		var _list=GR.getRecipesByTag(["Backpack"])
		for item in _list:
			var _item=ListItem.create_item(item)
			_item.selected.connect(_item_selected)
			list.add_child(_item)	

func _item_selected(ID):
	var _item=GR.getRecipe(ID)
	%lb_desc.text=_item.getCraftDescription(character)
	for item in %list_actions.get_children():
		%list_actions.remove_child(item)
		item.queue_free()

	var _bt=Button.new()
	_bt.text="Craft"
	#_bt.tooltip_text="_action.description"
	_bt.pressed.connect(doCraft.bind(_item))
	%list_actions.add_child(_bt)

func doCraft(_item:Recipe):
	var _res=_item.craftItem(character)
	%lbl_Result.text=_res.Msg
	#TODO crafting animation
	update_list()
	
func _on_bt_back_pressed() -> void:
	visible = false
	get_tree().paused = false
