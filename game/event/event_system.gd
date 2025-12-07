# 
#
extends Node
class_name EventSystem

var eventTriggers = {}
var eventChecks = {}

func _ready():
	Global.ES = self	
	#registerEventTriggers()		TODO
	#registerEvents()
