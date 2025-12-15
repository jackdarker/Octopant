extends Character
class_name Player


func post_sleep():
	pain = max(0,pain-20)
	fatigue = 0
	stat_changed.emit()
