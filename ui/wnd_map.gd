extends CanvasLayer

#TODO 
# display location-info: resources,quests, NPC
# fasttravel
# how to add mod-locations to map?
 

func _ready() -> void:
	visible = false

func _on_visibility_changed() -> void:
	if visible:
		pass #TODO

func _on_bt_back_pressed() -> void:
	visible = false
	get_tree().paused = false
