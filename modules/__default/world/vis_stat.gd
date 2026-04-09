extends NavigationScene

func _init() -> void:
	sceneID="vis_stat"

func enterScene():
	super()
	Global.hud.say("You get quite sore and have a hard time concentrating on your tasks.")
