extends CanvasLayer
class_name GameUI

signal menu_requested
signal inventory_requested

@onready var fullhud=$HBoxContainer
@onready var bt_hud_off=$bt_hud_on
@onready var ui_time=$HBoxContainer/LeftPanel/MarginContainer/VBoxContainer2/time_left
@onready var buttons=$HBoxContainer/Panel/MarginContainer/VBoxContainer/Panel/MarginContainer/ButtonGrid
@onready var msg=$HBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/RichTextLabel

func on_time_passed(_time):
	ui_time.get_node("Label").text= "Day "+var_to_str(Global.main.getDays()) + "      "+ Util.getTimeStringHHMM(Global.main.getTime())
	pass

func on_pc_stat_update():
	$HBoxContainer/LeftPanel/MarginContainer/VBoxContainer2/PlayerStatus.on_stat_update(Global.pc)

func say(text):
	msg.text=msg.text+"\n"+text
	pass

func clearOutput():
	msg.text=""

# hide buttons
func clearInput():
	for bt:BaseButton in buttons.get_children():
		bt.disabled=true
		bt.visible=false
		bt.text=""
		var pressed=bt.pressed.get_connections()
		for evt in pressed:
			bt.pressed.disconnect(evt.callable)
	pass

func addButton(text:String,tooltip:String,code:Callable,check=null,id:int=-1):
	for bt:BaseButton in buttons.get_children():
		if(!bt.visible):
			bt.text=text
			bt.disabled=false
			bt.visible=true
			bt.pressed.connect(code)
			break
	pass

func toggleHud(show:bool):
	if show:
		fullhud.visible=true
		bt_hud_off.visible=false
	else:
		fullhud.visible=false
		bt_hud_off.visible=true

func _onButton():
	pass


func _on_button_pressed() -> void:
	pass # Replace with function body.


func _on_bt_inventory_pressed() -> void:
	inventory_requested.emit()


func _on_bt_menu_pressed() -> void:
	menu_requested.emit()


func _on_bt_hud_off_pressed() -> void:
	toggleHud(bt_hud_off.visible)
