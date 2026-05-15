extends Node
class_name EventSystem

# most events only need to be checked at certain locations (by location-id) or at locations with tags
# others might occur anywhere

const TRIGGER = {EnterRoom=1,		# when exploring
	InSleep=2,						# while sleeping (dream)
	PostSleep=3,					# when waking
	InRoom=4,						# inject vis_scene in between navigation
	}

var eventLocation:Dictionary = {}
var eventOther = {}

func _init():
	pass

func registerEventTriggers():
	GR.initGameModules()
	pass

# location is either null or a location_id or a Tag-check
func registerEvent(trigger,event:EventBase, location, _args):
	if(location==null):
		eventOther[event.ID]=event
	else:
		eventLocation[{"location":location,"trigger":trigger,"eventID":event.ID}]=event
	pass

#func unregisterEvent(trigger, eventID):
#	pass

func triggerEvent(trigger,location,args)->bool:
	var _events:Array=getAvailableEvents(trigger,location,args)
	if(_events.size()<=0):
		return false
	var _evt=Util.pickRandomFromArray(_events,_events.map(func(x): return (x.getWeight())))
	return _evt.react(trigger,location,args)

func getAvailableEvents(trigger,location,_args):
	var _events=[]
	if(location==null):
		pass #todo
	else:
		for evtkey in eventLocation.keys():
			if(evtkey.location==location && evtkey.trigger==trigger):
				var evt=eventLocation[evtkey]
				if(evt.canRun(trigger,location,_args)):
					_events.push_back(evt)
	return _events
