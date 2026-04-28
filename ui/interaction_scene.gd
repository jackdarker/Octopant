class_name InteractionScene extends NavigationScene


# this scene runs a dialog between PC & NPC 

@export var back_image:Texture=null		#background-image, default color if null
@export var dialogue_gdscript  = null

var enabled_buttons : Array[Button] = []

func enterScene():
	Global.hud.hudMode=Hud.HUDMODE.Interaction
	Global.hud.visible=true
	Global.hud.clearOutput()
	Global.hud.clearInput()
	scene_ext=GR.getSceneExtensions(dialogue_gdscript,self)
	for ext in scene_ext:
		if ext.has_method("on_enterScene"):
			ext.on_enterScene()
	menu("")


func __displayImage(where,path):
	var _texture:Texture=null
	if path!="":
		_texture= load(path)
	if(where==1):
		#%img_char_1.texture=_texture
		Global.hud.show_picture_left(_texture)
	else:
		Global.hud.show_picture_right(_texture)
