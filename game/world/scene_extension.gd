class_name SceneExtension extends RefCounted

# beside adding completyl new scenes we can modify existing scenes

class Button_Config:
	var text:String="Nope"
	var tooltip:String=""
	var cb:Callable
	var enabled:Variant
	
	func _init(_text:String,_tooltip:String,_cb:Callable,_enabled=null):
		text=_text
		tooltip=_tooltip
		cb=_cb
		enabled=_enabled

var parent_scene:DefaultScene

func on_setupScene():
	pass

func on_enterScene():
	pass

# called when a menu is built
func get_buttons(menuid:String,buttons:Array)->Array:
	return(buttons)

func cb_menu(menuID:String,no_back:bool=false)->Callable:
	return parent_scene.menu.bind(menuID,no_back)
