class_name Util extends Object

# collection of static utility functions

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

## ["a","b"] -> "a,b"		
static func join(arr: Array, separator: String = ",") -> String:
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
	var _item=null
	if weights.size()==0:
		weights=items.map(func(_elmt):return 1)
	if(weights.size()!=items.size()):
		push_error("sizes dont match")
	var _max=weights.reduce(func(accum,elmnt):return(accum+elmnt))
	if(_max==null):
		return _item	#empty array
	var _rnd=randf_range(0.001,_max)
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

## creates a silhouette-image from image
static func createSilhouette(src_texture:Texture2D)->Texture2D:
	var threshold = 0.5                          # 0..1 alpha threshold
	var silhouette_color = Color(0,0,0,1)        # desired silhouette color (RGB, alpha=1)
	var src_img = src_texture.get_image()
	var w = src_img.get_width()
	var h = src_img.get_height()
	var dst_img = Image.create(w, h, false, Image.FORMAT_RGBA8)
	for y in range(h):
		for x in range(w):
			var c = src_img.get_pixel(x, y) # Color(r,g,b,a)
			if c.a > threshold:
				dst_img.set_pixel(x, y, Color(silhouette_color.r, silhouette_color.g, silhouette_color.b, 1.0))
			else:
				dst_img.set_pixel(x, y, Color(0,0,0,0)) # fully transparent
	return ImageTexture.create_from_image(dst_img);
