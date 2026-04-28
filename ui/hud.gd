class_name Hud extends CanvasLayer

signal menu_requested
signal log_requested
signal map_requested
signal inventory_requested

enum HUDMODE { Explore=0, Combat=1, Interaction=2}

var text_bullet = preload("res://ui/fragments/text_bullet.tscn")


@export var hudMode:HUDMODE=HUDMODE.Explore:
	set(value):
		show_picture_center(null)
		show_picture_left(null)
		show_picture_right(null)
		if(value==HUDMODE.Interaction):
			$HBoxContainer/LeftPanel.visible=false
			Util.delete_children(enemyList)	#cleanup list after combat
			enemyList.get_parent_control().visible=false
		elif(value==HUDMODE.Combat):
			enemyList.get_parent_control().visible=true
		else:
			$HBoxContainer/LeftPanel.visible=true
			Util.delete_children(enemyList)	#cleanup list after combat
			enemyList.get_parent_control().visible=false
		hudMode=value

@onready var fullhud=$HBoxContainer
@onready var bt_hud_off=$bt_hud_on
@onready var ui_time=$HBoxContainer/LeftPanel/MarginContainer/VBoxContainer2/time_left
@onready var buttons=$HBoxContainer/Panel/MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/ButtonGrid
@onready var msg=$HBoxContainer/Panel/MarginContainer/VBoxContainer/txt_main/RichTextLabel
@onready var pictureC=$HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/img_pic_C
@onready var pictureL=$HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/img_pic_L
@onready var pictureR=$HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/img_pic_R
@onready var playerHud=$HBoxContainer/LeftPanel/MarginContainer/VBoxContainer2/PlayerStatus
@onready var enemyList=$HBoxContainer/Panel/MarginContainer/VBoxContainer/list_enemys/HFlowContainer

func _ready() -> void:
	hudMode=HUDMODE.Explore

func on_time_passed(_time):
	ui_time.get_node("Label").text= "Day "+var_to_str(Global.main.getDays()) + "      "+ Util.getTimeStringHHMM(Global.main.getTime())
	pass

func on_pc_stat_update(_key,_data):
	playerHud.on_stat_update(Global.pc)

func on_pc_effect_update(_key):
	playerHud.on_effect_update(Global.pc,_key)
## who is dictionary of formating {"bgcolor":#49c9}	
func say(text,who:Dictionary={}):
	#msg.append_text("\n"+text)
	var label = text_bullet.instantiate()
	label.set_use_bbcode(true)
	label.set_fit_content(true)
	if(who.has("bgcolor")):
		text="[bgcolor="+who.bgcolor+"]"+text+"[/bgcolor]"
	label.set_text(text)
	msg.add_child(label)
	await get_tree().process_frame
	if(label):  #there might be occasions where clearOutput() is a called before the frame and label is already destroyed
		msg.get_parent().ensure_control_visible(label)

	#msg.typewrite("\n"+text)	doeant work with keeping old text

func show_picture_center(_texture:Texture):
	pictureC.texture=_texture
	pictureC.visible=true if _texture!=null else false

func show_picture_left(_texture:Texture):
	pictureL.texture=_texture
	pictureL.visible=true if _texture!=null else false

func show_picture_right(_texture:Texture):
	pictureR.texture=_texture
	pictureR.visible=true if _texture!=null else false

func clearOutput():
	$img_fade.visible=false
	#msg.text=""
	for child in msg.get_children():
		msg.remove_child(child)
		child.queue_free()

# hide buttons
func clearInput():
	for bt:BaseButton in buttons.get_children():
		bt.disabled=true
		bt.visible=false
		bt.text=""
		var pressed=bt.pressed.get_connections()			#Todo make lambda
		for evt in pressed:
			bt.pressed.disconnect(evt.callable)
		var mouse_entered=bt.mouse_entered.get_connections()
		for evt in mouse_entered:
			bt.mouse_entered.disconnect(evt.callable)
		var mouse_exited=bt.mouse_exited.get_connections()
		for evt in mouse_exited:
			bt.mouse_exited.disconnect(evt.callable)
	pass

func addButton(text:String,tooltip:String,code:Callable,check=null):
	for bt:BaseButton in buttons.get_children():	#TODO more...page if to many buttons
		#TODO favour undisabled button against disabled
		var tooltip2=tooltip
		if(!bt.visible): #choose the next unused button
			bt.text=text
			#bt.tooltip_text=tooltip
			bt.disabled=false
			if(check):
				var _res:Result=(check as Callable).call()
				if !_res.OK:
					bt.disabled=true
				tooltip2+=_res.Msg
			bt.visible=true
			bt.pressed.connect(code)
			bt.mouse_entered.connect(Global.toolTip.showTooltip.bind(bt,text,tooltip2))
			bt.mouse_exited.connect(Global.toolTip.hideTooltip.bind(bt))
			break
	pass

func fade():
	$anim_fade.play("fade")

func toggleHud(_show:bool):
	if _show:
		fullhud.visible=true
		bt_hud_off.visible=false
	else:
		fullhud.visible=false
		bt_hud_off.visible=true


func _on_bt_inventory_pressed() -> void:
	inventory_requested.emit()


func _on_bt_menu_pressed() -> void:
	menu_requested.emit()


func _on_bt_hud_off_pressed() -> void:
	toggleHud(bt_hud_off.visible)


func _on_bt_map_pressed() -> void:
	map_requested.emit()


func _on_bt_quest_pressed() -> void:
	log_requested.emit()
