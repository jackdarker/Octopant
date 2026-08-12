extends Control

signal filechange

@export var save_only:bool=false:
	set(value):
		%bt_load.visible=!value
		%bt_delete.visible=!value
		
@export var can_save:bool=false:
	set(value):
		%bt_save.visible=value

@export var file:String="the file":
	set(value):
		file=value
		%file.text=value

@export var text:String="unknown":
	set(value):
		%label.text=value


func _on_bt_save_pressed() -> void:
	var _newfile=Global.newSaveFileName()
	Global.saveToFile(_newfile)
	Global.deleteSaveFile(file)
	file=_newfile
	filechange.emit()


func _on_bt_load_pressed() -> void:
	Global.loadFromFile(file)


func _on_bt_delete_pressed() -> void:
	Global.deleteSaveFile(file)
	filechange.emit()
