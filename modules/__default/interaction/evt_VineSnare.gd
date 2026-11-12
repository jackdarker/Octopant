extends SceneExtension

const sceneID="evt_VineSnare"
var avatar_player
var avatar_crab = load("res://assets/images/chars/Crab.png")
const NPC_Format = {"bgcolor":Color.DARK_ORANGE}

func on_enterScene():
	#avatar_player = Global.pc.getBustImage()
	#parent_scene.__displayImage(1,avatar_player)
	#parent_scene.__displayImage(2,Util.createSilhouette(avatar_crab))
	pass

func get_buttons(menuid:String,buttons:Array):
	var _room=GR.getFlag("Default.Dungeon_Room","")
	var _target=GR.getFlag("Default.Dungeon_TargetRoom","")
	if(menuid==""):
		Global.hud.say("As you walk along, some tentacle push from the ground beneath you.")
		buttons.push_back(Button_Config.new("Dodge away (Agility)","",cb_menu("dodge",true)))
		buttons.push_back(Button_Config.new("Stand still (Strength)","",cb_menu("stop",true)))
	if(menuid=="dodge"):
		#todo
		Global.hud.say("Quickly stepping out of the way you avoided to be grabbed.")
		buttons.push_back(Button_Config.new("Next","",Global.main.removeScene.bind(parent_scene)))
	return(buttons)
