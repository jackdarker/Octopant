extends "res://ui/navigation_scene.gd"


func _read()-> void:
	pass

func _on_bt_home_pressed() -> void:
	show_Intro()
	pass # Replace with function body.


func _on_bt_explore_pressed() -> void:
	pass # Replace with function body.

func show_Intro():
	var s = ResourceLoader.load("res://ui/message_box.tscn").instantiate()
	s.text= "you wake up at the beach"
	get_node("../../MessageHolder").add_child(s)
