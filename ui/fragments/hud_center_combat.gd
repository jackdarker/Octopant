class_name HudCenterCombat extends HudCenterDefault

@onready var enemyList=$VBoxContainer/HBoxContainer2/VBoxContainer/scroll_enemys/lst_enemys
func _ready() -> void:
	Util.delete_children(enemyList)
	show_picture_center(null)
	show_picture_left(null)
	show_picture_right(null)
	pass

func show_picture_right(_texture:Texture):
	__fix_image_size(_texture,%pictureR)
