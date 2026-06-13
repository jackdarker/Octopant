class_name Log extends Object

static var start_time=Time.get_ticks_usec()

static func _deltaTimeText()->String:
	return (str((Time.get_ticks_usec()-start_time)/1000)+"ms   ")

static func error(text: String):
	printerr(_deltaTimeText()+text)
	#Console.printLine("[color=red]"+text+"[/color]")

static func warn(text: String):
	print(_deltaTimeText()+text)
	#Console.printLine("[color=yellow]"+text+"[/color]")

static func verbose(text: String):
	print(_deltaTimeText()+text)
	#Console.printLine(text)
