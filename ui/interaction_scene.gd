class_name InteractionScene extends NavigationScene


# this scene runs a dialog between PC & NPC 

@export var back_image:Texture=null		#background-image, default color if null
@export var dialogue_gdscript  = null
var args:Array
var chars:Array[Character]=[]	#characters partaking in dialog,chars[0] is initiator

var enabled_buttons : Array[Button] = []


func setupScene():
	for arg in args:
		if(arg is Character):
			chars.push_back(arg)
	#super() doesnt have sceneExt
	scene_ext=GR.getSceneExtensions(dialogue_gdscript,self)
	for ext in scene_ext:
		ext.on_setupScene()

func enterScene():
	Global.hud.hudMode=Hud.HUDMODE.Interaction
	Global.hud.visible=true
	Global.hud.clearOutput()
	Global.hud.clearInput()
	
	for ext in scene_ext:
		if ext.has_method("on_enterScene"):
			ext.on_enterScene()
	menu("")

func canSave()->bool:
	return false	#TODO fix saving Interactions 

func __displayImage(where,_texture:Texture2D):
	if(where==1):
		Global.hud.show_picture_left(_texture)
	else:
		Global.hud.show_picture_right(_texture)
