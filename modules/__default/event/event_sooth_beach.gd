extends EventBase

# this is alternative of EventHurtBeach

func _init():
	ID="EventSoothBeach"
	EventName="Take a walk at the beach"
	super()

func react(_triggerID,_location,_args)->bool:
	Global.hud.clearInput()
	Global.hud.say("Walking along the shifting sand looking for something useful got your thoughts shifted into a different direction.")
	Global.pc.getStat(StatEnum.Lust).modify(-10)
	Global.main.getCurrentScene().continueScene()
	return true
	
func canRun(_trigger,_location,_args)->bool:
	return true

func getWeight()->float:
	return 0.5
