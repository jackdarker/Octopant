extends CanvasLayer

func _ready() -> void:
	visible = false

func _on_visibility_changed() -> void:
	if visible:
		Tutorials.show("basic_stats")
		pass #TODO

func _on_bt_back_pressed() -> void:
	visible = false
	get_tree().paused = false
