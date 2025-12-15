extends VBoxContainer

@onready var pain_bar=$HBoxContainer/barHealth

func on_stat_update(who:Character):
	pain_bar.max_value=who.painMax
	pain_bar.value=who.pain
