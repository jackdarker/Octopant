class_name Hud extends CanvasLayer

signal menu_requested
signal log_requested
signal map_requested
signal setup_requested
signal inventory_requested
signal status_requested

enum HUDMODE { Explore=0, Combat=1, Interaction=2}
enum HUDPANEL {Menu=0, Left=1, Center=2, Choice=3}
## Explore		TODO Main-Layouts + swapable subpanels
#   ---------------------------------
#	|		|						|
#	|	S	|		D				|
#	|		|						|
#	|		|						|
#	---------						|
#	|		|------------------------
#	|	M	|		B				|
#	|		|						|
#	---------------------------------
## Interaction
#   ---------------------------------
#	||								|
#	||				D				|
#	||								|
#	||								|
#	--								|
#	||-------------------------------
#	||				B				|
#	||								|
#	---------------------------------
## Combat
#   ---------------------------------
#	|		|		NPC				|
#	|	S	|-----------------------|
#	|		|		D				|
#	|		|						|
#	---------						|
#	|		|------------------------
#	|	M	|		B				|
#	|		|						|
#	---------------------------------



@export var hudMode:HUDMODE=HUDMODE.Explore:
	set(value):
		show_picture_center(null)
		show_picture_left(null)
		show_picture_right(null)
		if(value==HUDMODE.Interaction):
			$HBoxContainer/LeftPanel.visible=false
		elif(value==HUDMODE.Combat):
			pass
		else:
			$HBoxContainer/LeftPanel.visible=true
		hudMode=value

@onready var fullhud=$HBoxContainer
@onready var bt_hud_off=$bt_hud_on
@onready var ui_time=$HBoxContainer/LeftPanel/MarginContainer/VBoxContainer2/time_left
@onready var playerHud=$HBoxContainer/LeftPanel/MarginContainer/VBoxContainer2/PlayerStatus
@onready var hudCenter=$HBoxContainer/Panel/Center
@onready var map=$HBoxContainer/LeftPanel/MarginContainer/VBoxContainer2/Map

func _ready() -> void:
	hudMode=HUDMODE.Explore
	pass

func _process(delta: float) -> void:
	pass #map.texture=Global.World.mapview.get_texture()
	
	
func configureHudCenter(hudNew:Control):
	#if the actual control matches the type of new control, dont change
	#because get_class does only handle builtin types, we have to compare script paths 
	if(hudCenter.get_script().resource_path==hudNew.get_script().resource_path):
		return
	var _p=hudCenter.get_parent()
	_p.remove_child(hudCenter)
	_p.add_child(hudNew)
	hudCenter.queue_free()
	hudCenter=hudNew
	pass

func on_time_passed(_time):
	ui_time.get_node("Label").text= "Day "+var_to_str(Global.main.getDays()) + "      "+ Util.getTimeStringHHMM(Global.main.getTime())
	pass

func on_pc_stat_update(_key,_data):
	playerHud.on_stat_update(Global.pc)

func on_pc_effect_update(_key):
	playerHud.on_effect_update(Global.pc,_key)
	
## who is dictionary of formating {"bgcolor":#49c9}	
func say(text,who:Dictionary={}):
	hudCenter.say(text,who)

#Todo  "Global.hud.hudCenter.show_..."
func show_picture_center(_texture:Texture):
	hudCenter.show_picture_center(_texture)

func show_picture_left(_texture:Texture):
	hudCenter.show_picture_left(_texture)

func show_picture_right(_texture:Texture):
	hudCenter.show_picture_right(_texture)

func clearOutput():
	$img_fade.visible=false
	hudCenter.clearOutput()

# hide buttons
func clearInput():
	hudCenter.clearInput()

func addButton(text:String,tooltip:String,code:Callable,check=null):
	hudCenter.addButton(text,tooltip,code,check)


func fade():
	$anim_fade.play("fade")
	await $anim_fade.animation_finished
	pass

func toggleHud(_show:bool):
	if _show:
		fullhud.visible=true
		bt_hud_off.visible=false
	else:
		fullhud.visible=false
		bt_hud_off.visible=true


func _on_bt_inventory_pressed() -> void:
	inventory_requested.emit()

func _on_bt_status_pressed() -> void:
	status_requested.emit()

func _on_bt_menu_pressed() -> void:
	menu_requested.emit()


func _on_bt_hud_off_pressed() -> void:
	toggleHud(bt_hud_off.visible)


func _on_bt_map_pressed() -> void:
	map_requested.emit()

func _on_bt_settings_pressed() -> void:
	setup_requested.emit()

func _on_bt_quest_pressed() -> void:
	log_requested.emit()
