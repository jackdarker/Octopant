extends CanvasLayer
class_name GameUI

@onready var ui_time=$time_left

func on_time_passed(time):
	$time_left.get_node("ProgressBar/Label").text= "Day "+var_to_str(Global.main.getDays()) + "      "+ Util.getTimeStringHHMM(Global.main.getTime())
	pass

func on_pc_stat_update():
	$FoldableContainer/MarginContainer/PlayerStatus.on_stat_update(Global.pc)
