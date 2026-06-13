extends Node
# heavily modified from https://github.com/jitspoe/godot-console

#@onready var control := Control.new()
var consoleScene = preload("res://ui/wnd_debug.tscn")
var console


var commands = {}

signal onConsoleOutput(text)

func _ready():
	#var canvas_layer := CanvasLayer.new()
	#canvas_layer.layer = 3
	#add_child(canvas_layer)
	#control.anchor_bottom = 0.9
	#control.anchor_right = 1.0
	#canvas_layer.add_child(control)
	#control.visible = false
	
	console = consoleScene.instantiate()
	#control.add_child(console)
	add_child(console)
	var _ok = onConsoleOutput.connect(console.printLine)
	var _ok2 = console.consoleClosed.connect(toggleConsole)

	self.process_mode=PROCESS_MODE_ALWAYS

	printLine("This is a development console")
	addCommand("quit", self, "quit")
	addCommand("help", self, "help")

func quit():
	get_tree().quit()

func help():
	printLine(getCommandsHelp())

func _input(event : InputEvent):
	if (event is InputEventKey):
		if (event.pressed && event.physical_keycode == 96):	# "^"
			if (event.pressed):
				toggleConsole()
				get_viewport().set_input_as_handled()
		elif (event.pressed && event.physical_keycode == KEY_ESCAPE && console.visible):
			if (event.pressed):
				toggleConsole()
				get_viewport().set_input_as_handled()
				
func toggleConsole():
	console.visible = !console.visible

## note:params are applied as string unless you add ":int" to them
func addCommand(command_name : String, object : Object, function_name : String, params : Array = [],returns : Array = [], description : String = "No description provided"):
	var _func
	var _params=[]
	for _foo in object.get_method_list():
		if(_foo.name==function_name):
			_func=_foo
			break
	if !_func:
		Log.error("no function of name "+function_name)
	#else:							#because methods sometimes have no type or varianttype declared, we cannot infere proper type
	#	for _arg in _func.args:
	#		_params.push_back(_arg.name)
	commands[command_name] = {
		"function": Callable(object, function_name),
		"object": weakref(object),
		"params": params,
		"returns": returns,
		"description": description,
	}
	#var _b=commands[command_name]["function"].is_valid()
	#var _c=commands[command_name]["function"].get_argument_count()
	#var _s=commands[command_name]["function"].get_method()
	

func removeCommand(command_name : String):
	commands.erase(command_name)

func doTextCommand(command:String):
	printLine(command)
	var split_text:Array = command.split(" ", true)
	if (split_text.size() > 0):
		var command_string = split_text[0]
		if (commands.has(command_string)):
			var command_entry = commands[command_string]
			
			var ref = command_entry["object"]
			if(ref.get_ref() == null):
				printLine("[color=red]Object was destroyed, command is invalid.[/color]")
				return
			
			split_text.pop_front()
			if(split_text.size() != command_entry["params"].size()):
				printLine("[color=red]Wrong amount of arguments, expected:[/color] "+str(command_entry["params"].size()))
				return
			var _c=command_entry["function"].get_argument_count()
			var _s=command_entry["function"].get_method()
			if(!command_entry["function"].is_valid()):
				printLine("[color=red]Invalid callable[/color]")
				return
			
			var _args=[]	#convert string to other types if needed
			for _i in range(split_text.size()):
				var _tdef=command_entry["params"][_i].split(":", true)
				if(_tdef.size()>1 && _tdef[1]=="int"):
					_args.push_back(split_text[_i].to_int())
				else:	
					_args.push_back(split_text[_i])	
			var _res=command_entry["function"].callv(_args)
			if(_res):
				printLine(str(_res))

		else:
			printLine("[color=red]Command not found.[/color]")

func printLine(text: String):
	onConsoleOutput.emit(text)

func getCommandsHelp():
	var result = ""
	for command_name in commands:
		var command = commands[command_name]
		result += command_name + " - args=" + str(command["params"])+ " - returns=" + str(command["returns"])+" - " + str(command["description"])+"\n"
		
	return result
