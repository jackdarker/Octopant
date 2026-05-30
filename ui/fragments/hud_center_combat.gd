class_name HudCenterCombat extends HudCenterDefault

@onready var enemyList=$VBoxContainer/list_enemys/HFlowContainer

func _ready() -> void:
	Util.delete_children(enemyList)
	show_picture_center(null)
	show_picture_left(null)
	show_picture_right(null)
	pass
