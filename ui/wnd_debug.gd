extends CanvasLayer

signal consoleClosed

var savedText = ""

func _ready() -> void:
	visible=false

func _on_visibility_changed() -> void:
	if !%output:
		return
	if(visible):
		#%output.text = savedText
		%input.grab_focus()
		%help.text = "Console commands:\n"+DbgConsole.getCommandsHelp()


func printLine(text : String):
	if (!%output):
		return
	savedText += text+"\n"
	if(savedText.length() > 20000):
		savedText = savedText.substr(savedText.length() - 10000)
	if(visible):
		%output.text = savedText
		%input.grab_focus()

func _on_bt_back_pressed() -> void:
	consoleClosed.emit()


func _on_input_text_submitted(new_text: String) -> void:
	DbgConsole.doTextCommand(new_text)
	%input.text = ""

func _on_bt_clear_pressed() -> void:
	savedText = ""
	%output.text = ""
