extends Node
class_name MainScene

signal time_passed(_secondsPassed)
signal saveLoadingFinished

func _ready() -> void:
	Global.gameUI = $Hud	# load("res://ui/hud.tscn").instance()	#GameUI
