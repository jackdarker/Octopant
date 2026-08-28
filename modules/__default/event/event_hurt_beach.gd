extends EventBase

func _init():
	ID="EventHurtBeach"
	EventName="Take a walk at the beach"
	super()

func react(_triggerID,_location,_args)->bool:
	Global.hud.clearInput()
	Global.hud.say("Accidently you hurt yourself by stepping on some pointed seashell hidden in the wet sand.")
	Global.pc.getStat(StatEnum.Pain).modify(10)
	Global.pc.getStat(StatEnum.Lust).modify(-10)
	GR.unlockRecipe("knife_seashell")
	Global.main.getCurrentScene().continueScene()
	return true
	
func canRun(_trigger,_location,_args)->bool:
	return true

func getWeight()->float:
	return 0.5 if Global.pc.getStat(StatEnum.Lust).value_percent<50 else 1.0
