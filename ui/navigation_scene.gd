extends "res://ui/default_scene.gd"

# shows a view with buttons to explore or move on
var msg_scn=ResourceLoader.load("res://ui/message_box.tscn")
var msg:MessageBox
var state:int =0

func _ready() -> void:
	enterScene()
	pass

func enterScene():
	Global.pc.location=self.sceneID
	Global.hud.visible=true
	Global.hud.clearOutput()
	Global.hud.clearInput()
	
func continueScene():
	Global.hud.clearInput()
	Global.hud.addButton("next","",enterScene)

# override this ! 
func on_button(_i:int):
	pass

func navigate_home():
	Global.main.runScene("nav_home")


func show_msg():
	msg.on_button.connect(on_button)
	get_node("../../MessageHolder").add_child(msg)
