extends VBoxContainer

@onready var pain_bar=$HBoxContainer/barPain
@onready var fatigue_bar=$HBoxContainer/barFatigue

func _ready() -> void:
	fatigue_bar.text="fatigue"

func on_stat_update(who:Character):
	var _n=who.getStat("pain")
	pain_bar.max_value=_n.ul
	pain_bar.value=_n.value
	_n=who.getStat("fatigue")
	fatigue_bar.max_value=_n.ul
	fatigue_bar.value=_n.value
