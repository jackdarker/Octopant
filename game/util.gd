extends Object
class_name Util

# collection of static utility functions

static func join(arr: Array, separator: String = "") -> String:
	var output = ""
	for s in arr:
		output += str(s) + separator
	output = output.left( output.length() - separator.length() )
	return output

# input splitOnFirst("Test.Meow.Woof", ".")
# output ["Test", "Meow.Woof"]
static func splitOnFirst(text: String, separator: String):
	var stuff = text.split(separator)
	
	if(stuff.size() <= 1):
		return stuff
	
	var firstEntry = stuff[0]
	stuff.remove(0)
	
	return [firstEntry, join(stuff, separator)]

# input in seconds
# output "03:25"
static func getTimeStringHHMM(t):
	var _seconds = floor(fmod(t, 60.0))
	var _minutes = floor(fmod(t/60.0, 60.0))
	var _hours = floor(t/3600.0)
	var time = "%02d:%02d" % [_hours, _minutes]
	return time

static func getStackFunction(depth = 2):
	var stack = get_stack()
	if(stack == null || !(stack is Array) || stack.size() <= (depth + 1)):
		return "No stack available"

	var text = "File: "+stack[depth]["source"]+" Line: "+str(stack[depth]["line"])
	return text

static var STAT={Pain="pain"}
