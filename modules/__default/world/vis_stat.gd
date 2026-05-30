extends NavigationScene

func _init() -> void:
	sceneID="vis_stat"

func enterScene():
	super()
	Global.hud.say("You get tired and have a hard time concentrating on your tasks. 
	Getting some rest would be fine.")
