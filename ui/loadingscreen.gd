extends Control

func _ready():
	if(GlobalRegistry.isInitialized):
		Global.goto_scene("res://UI/MainMenu/MainMenu.tscn")
		return
	#OPTIONS.setSupportsVertical(true)
	var _ok = GlobalRegistry.connect("loadingUpdate", onGlobalRegistryUpdate)
	var _ok2 = GlobalRegistry.connect("loadingFinished", onGlobalRegistryFinishedUpdate)
	GlobalRegistry.registerEverything()

func onGlobalRegistryUpdate(percent, whatnext):
	$ProgressBar.value = percent * 100.0
	$ProgressBar/Label.text = str(whatnext) #str(Util.roundF(percent*100.0, 1))+"% " + 

func onGlobalRegistryFinishedUpdate():
	Global.goto_scene("res://ui/main_menu.tscn")
