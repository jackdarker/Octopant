extends "res://ui/default_scene.gd"

# shows a view with buttons to explore or move on
var msg_scn=ResourceLoader.load("res://ui/message_box.tscn")
var msg:MessageBox
var state:int =0

func _ready() -> void:
	pass

# override this ! 
func on_button(i:int):
	pass

func navigate_home():
	Global.main.goto_scene("res://modules/default/world/nav_home.tscn")


func show_msg():
	msg.on_button.connect(on_button)
	get_node("../../MessageHolder").add_child(msg)
