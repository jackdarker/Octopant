class_name Util extends Object

# collection of static utility functions

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
		
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

## picks an item from an array; you might define different weight (float or int) per item 
static func pickRandomFromArray(items:Array,weights:Array=[])-> Variant:
	if weights.size()==0:
		weights=items.map(func(_elmt):return 1)
	if(weights.size()!=items.size()):
		push_error("sizes dont match")
	var _max=weights.reduce(func(accum,elmnt):return(accum+elmnt))
	var _rnd=randf_range(0.001,_max)
	var _item=null
	var _lo
	var _up=_max
	var i=items.size()
	while(i>0):
		i-=1
		_lo=_up-weights[i]
		if(_lo<_rnd && _rnd<=_up):
			_item=items[i]
			break
		_up=_lo
		
	return _item
