extends EventBase

# an event that gives the player some loot

func _init():
	super()
	ID="EventHurtBeach"

func react(_triggerID, _args)->bool:
	Global.ui.say("Accidently you hurt yourself by stepping on some pointed seashell hidden in the wet sand.")
	Global.pc.getStat("pain").modify(10)
	Global.main.getCurrentScene().continueScene()
	return true
	
func canRun()->bool:
	return true
