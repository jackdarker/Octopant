extends EventBase

func _init():
	ID="EventCliffBoatStart"
	EventName="look for the boat"
	super()

func react(_triggerID,_location,_args)->bool:
	Global.hud.clearInput()
	Global.hud.say("While climbing around the foot of the cliff, you get to a point where you can see the boat that you spotted from the top of the cliff.")
	Global.hud.say("\"I guess thats the closest point I can get to it.\"")
	Global.hud.addButton("Try to swim to the boat","",_engage,null)
	Global.hud.addButton("...or dont","",_ignore,null)
	return true
	
func canRun(_trigger,_location,_args)->bool:
	var q=Global.QS.active.get_quest_from_id("visit_boatwreck")
	if(q):
		return true
	return false

func getWeight()->float:
	return 2.0

func _ignore():
	Global.hud.say("")
	Global.main.getCurrentScene().continueScene()

func _engage():
	Global.hud.say("TODO")
	Global.main.getCurrentScene().continueScene()
