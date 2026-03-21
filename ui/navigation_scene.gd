extends "res://ui/default_scene.gd"

# shows a view with buttons to explore or move on

var scene_ext:Array[RefCounted]

var msg_scn=ResourceLoader.load("res://ui/message_box.tscn")
var msg:MessageBox
var state:int =0
var menustack:Array[String]=[]

func _ready() -> void:
	enterScene()
	pass

func load_extensions():
	pass

func enterScene():
	Global.pc.location=self.sceneID
	Global.hud.visible=true
	Global.hud.clearOutput()
	Global.hud.clearInput()

# call this after event finishs to continue previous scene	
func continueScene():
	Global.hud.clearInput()
	Global.hud.addButton("next","",enterScene)

func set_bg(bg:Texture2D):
	%bg_image.texture=bg

func menu(menuid:String):
	var buttons:Array[SceneExtension.Button_Config]=[]
	Global.hud.clearInput()
	for ext in scene_ext:
		if ext.has_method("get_buttons"):
			buttons=ext.get_buttons(menuid,buttons)
	
	if menuid!="main":
		Global.hud.addButton("back","",menu_back)
	
	for bt in buttons:
		Global.hud.addButton(bt.text,bt.tooltip,bt.cb,bt.enabled)	

func menu_back():
	menustack.pop_back()
	menu(menustack.pop_back())

# override this ! 
func on_button(_i:int):
	pass

func navigate_home():
	Global.main.runScene("nav_home")


func show_msg():
	msg.on_button.connect(on_button)
	get_node("../../MessageHolder").add_child(msg)
