extends Control

func _ready():
	if(GR.isInitialized):
		onGlobalRegistryFinishedUpdate()
		return
	#OPTIONS.setSupportsVertical(true)
	var _ok = GR.connect("loadingUpdate", onGlobalRegistryUpdate)
	var _ok2 = GR.connect("loadingFinished", onGlobalRegistryFinishedUpdate)
	GR.registerEverything()

func onGlobalRegistryUpdate(percent, whatnext):
	$ProgressBar.value = percent * 100.0
	$ProgressBar/Label.text = str(whatnext) #str(Util.roundF(percent*100.0, 1))+"% " + 

func onGlobalRegistryFinishedUpdate():
	Global.loadSettings()
	Global.goto_scene("res://ui/main_menu.tscn")
