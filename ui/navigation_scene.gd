extends "res://ui/default_scene.gd"

# shows a view with buttons to explore or move on

var scene_ext:Array[SceneExtension]

var msg_scn=ResourceLoader.load("res://ui/message_box.tscn")
var msg:MessageBox
var state:int =0
var menustack:Array[String]=[]	#sub-menu path

func _ready() -> void:
	enterScene()
	pass

#override this
func setupScene(_args:Array):
	pass

func enterScene():
	Global.pc.location=self.sceneID
	scene_ext=GR.getSceneExtensions(self.sceneID,self)
	Global.hud.visible=true
	Global.hud.clearOutput()
	Global.hud.clearInput()
	for ext in scene_ext:
		if ext.has_method("on_enterScene"):
			ext.on_enterScene()
	menu("")

# call this after event finishs to continue previous scene	
func continueScene():
	Global.hud.clearInput()
	Global.hud.addButton("next","",enterScene)

func set_bg(bg:Texture2D):
	%bg_image.texture=bg

func get_bg()->Texture2D:
	return %bg_image.texture

# menuid depends on the scene; usually "walk","explore","rest","craft"
func menu(menuid:String):
	var buttons:Array[SceneExtension.Button_Config]=[]
	Global.hud.clearInput()
	if menuid!="":
		menustack.push_back(menuid)
		Global.hud.addButton("back","",menu_back)
	else:
		menustack=[""]
		
	for ext in scene_ext:
		if ext.has_method("get_buttons"):
			buttons=ext.get_buttons(menuid,buttons)
	
	for bt in buttons:		#TODO if to many buttons make subpages
		Global.hud.addButton(bt.text,bt.tooltip,bt.cb,bt.enabled)	
	

func menu_back():
	menustack.pop_back()
	menu(menustack.pop_back())

func navigate_home():
	Global.main.runScene("nav_home")
