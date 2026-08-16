extends SceneExtension

## submision to otter

const sceneID="dlg_sbm_otter"
var avatar_player
var avatar_mob = load("res://assets/images/chars/otter.png")
const NPC_Format = {"bgcolor":Color.LIME_GREEN}

func on_enterScene():
	avatar_player = Global.pc.getBustImage()
	parent_scene.__displayImage(1,avatar_player)


func get_buttons(menuid:String,buttons:Array):
	var _met:int=0#GR.getModuleFlag("Squishl","Lutes_Met",0)
	if(menuid==""):
		parent_scene.__displayImage(2,avatar_mob)
		Global.hud.say("I'm always up for some playing !",NPC_Format)
		#buttons.push_back(Button_Config.new("Oh hello. Can we talk?","",cb_menu("requestTalk",true)))
		buttons.push_back(Button_Config.new("Next","",cb_menu("leave",true)))
	if(menuid=="leave"):
		Global.hud.say("With that, the otter-boy hurrys away.")
		Global.pc.getStat(StatEnum.Pain).modify(-60,{"ll":30}) # lower pain or it triggers defeat again
		Global.pc.getStat(StatEnum.Lust).modify(-60,{"ll":30})
		buttons.push_back(Button_Config.new("Done","",Global.main.removeScene.bind(parent_scene)))
	return(buttons)
