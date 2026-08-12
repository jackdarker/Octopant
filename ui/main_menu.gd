extends Control

func _ready() -> void:
	pass

func _on_bt_quit_pressed() -> void:
	Global.quitGodot()

func _on_bt_main_pressed() -> void:
	Global.goto_scene("res://Scenes/main_menu.tscn")

func _on_bt_start_pressed() -> void:
	Global.goto_scene("res://game/main_scene.tscn")

func _on_bt_load_pressed() -> void:
	$WndPause.visible=true

func _on_bt_settings_pressed() -> void:
	$WndSettings.visible=true

#called by save-dialog
func canSave()->bool:
	return false
