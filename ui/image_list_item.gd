class_name ListItem extends Control

signal selected(path:String)

static var SceneListItem
static func create_item(data)-> ListItem:
	if(!SceneListItem):
		SceneListItem = load("res://ui/image_list_item.tscn")
	var _Item=SceneListItem.instantiate()
	#var image = Image.load_from_file(data.getInventoryImage())
	var _tex:Texture2D = load(data.getInventoryImage())
	var image = _tex.get_image()
	var ThumbnailSize = 128	#TODO
	var Width =0
	var Height = 0
	var Ratio = image.get_width() / float(image.get_height())
	if Ratio>= 1.0:
		Width = ThumbnailSize;
		Height = (Width * image.get_height()) / float(image.get_width());
	else:
		Height = ThumbnailSize;
		Width = (Height * image.get_width()) / float(image.get_height());

	image.resize(Width,Height)
	_Item.texture=ImageTexture.create_from_image(image)
	_Item.data=data

	return _Item

var data:
	set(value):
		data=value
		_refresh()
	get:
		return(data)

var _text:String:
	set(value):
		$Control/Label.text=value
	get:
		return($Control/Label.text)

var _text2:String:
	set(value):
		$lb_amount.text=value
	get:
		return($lb_amount.text)

var texture:
	set(value):
		$Control/TextureRect.texture=value	
	get:
		return $Control/TextureRect.texture	

func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed && event.button_index==MOUSE_BUTTON_LEFT:
			pass

func _refresh():
	_text=data.getName()
	_text2=str(data.amount)
	_resize.call_deferred()

func _resize():
	#hack to avoid having a fixed custom-minimum-size
	#TODO if this causes the scrollbar to appear, it will not perfectly fit
	var _size=$Control/TextureRect.size+Vector2(4,4)
	_size.y+=$Control/Label.size.y
	custom_minimum_size=_size


func _on_focus_entered() -> void:
	$Focus.visible=true #.add_theme_color_override("normal",Color.ANTIQUE_WHITE)
	selected.emit(self.data.getID())
	pass # Replace with function body.


func _on_focus_exited() -> void:
	$Focus.visible=false #$Panel.remove_theme_color_override("normal")
	pass # Replace with function body.
