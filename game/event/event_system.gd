extends Node
class_name EventSystem

# most events only need to be checked at certain locations (by location-id) or at locations with tags
# others might occur anywhere

const TRIGGER = {EnterRoom=1,
	InSleep=2,
	PostSleep=3,
	}

var eventLocation:Dictionary = {}
var eventOther = {}

func _init():
	pass

func registerEventTriggers():
	GlobalRegistry.initGameModules()
	pass

# location is either null or a location_id or a Tag-check
func registerEvent(trigger,event:EventBase, location, args):
	if(location==null):
		eventOther[event.id]=event
	else:
		eventLocation[{"location":location,"trigger":trigger,"eventid":event.id}]=event
	pass

#func unregisterEvent(trigger, eventid):
#	pass

func triggerEvent(trigger,location,args):
	var _events=getAvailableEvents(trigger,location,args)
	if(_events.size()<=0):
		return false
	
	return _events[randi_range(0,_events.size()-1)].react("","")

func getAvailableEvents(trigger,location,args):
	var _events=[]
	if(location==null):
		pass #todo
	else:
		for evtkey in eventLocation.keys():
			if(evtkey.location==location && evtkey.trigger==trigger):
				var evt=eventLocation[evtkey]
				if(evt.canRun()):
					_events.push_back(evt)
	return _events
