extends EventBase

func _init():
	super()
	ID="EventMeetSquishlBeach"

func react(_triggerID, _args)->bool:
	Global.hud.say("As you walk the beach you spot a squid sitting in a small pool of water.")
	Global.hud.addButton("Ignore it","",_ignore,null)
	Global.hud.addButton("Inspect closer","",_inspect,null)
	return true
	
func canRun()->bool:
	return (GR.getModuleFlag("Squishl","Squishl_Saved",0)==0)

func _ignore():
	Global.hud.say("\n")
	Global.hud.say("You quickly pass by, leaving the hapeless creature to its fate.")
	GR.setModuleFlag("Squishl","Squishl_Saved",-1)
	Global.main.getCurrentScene().continueScene()

func _inspect():
	Global.hud.clearInput()
	Global.hud.say("\n")
	Global.hud.say("Some octopus got trapped in this pool, possibly last night when the storm throwed the waves further up the shore then ever.")
	Global.hud.say("The creature might not survive for much longer as the water heats up by the sun.")
	Global.hud.addButton("Ignore it","",_ignore,null)
	Global.hud.addButton("Help","",_help,null)

func _help():
	Global.hud.clearInput()
	Global.hud.say("\n")
	Global.hud.say("Unfortunalty you dont have anything with you to catch the sqid and cary it down to the sea.")
	Global.hud.say("You would need to use your hands and you arent sure what it could do to you. Have those things teeth?")
	Global.hud.addButton("Leave it","",_ignore,null)
	Global.hud.addButton("Use your hands","",_help2,null)

func _help2():
	Global.hud.clearInput()
	Global.hud.clearOutput()
	Global.hud.say("So, you kneel down and try to snatch the squid.")
	Global.hud.say("Of course it trys to get away but it already seems to weak and you can get a hold of its rubbery, squishy body.")
	Global.hud.say("Having a hard time to keep its squirming mass craddled to your chest, you quickly make your way down to the waves.")
	Global.hud.say("Walking some steps into the now flat waves, you release the critter into the water. Just a second later the octopus dashs forth, deeper into the saving ocean.")
	Global.hud.say("You wonder if the creature would have recognized your help.")
	GR.setModuleFlag("Squishl","Squishl_Saved",1)
	Global.main.getCurrentScene().continueScene()
