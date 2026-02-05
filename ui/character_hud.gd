extends VBoxContainer

@onready var pain_bar=$HBoxContainer/barPain
@onready var fatigue_bar=$HBoxContainer/barFatigue
@onready var lust_bar=$HBoxContainer/barLust
@onready var listEffects=$listEffects

var characterName:String="unknown":
	set(value):
		characterName=value
		%lbl_name.text=value

func _ready() -> void:
	fatigue_bar.text="fatigue"
	lust_bar.text="lust"

func on_stat_update(who:Character):
	on_bust_update(who)
	var _n=who.getStat("pain")
	pain_bar.max_value=_n.ul
	pain_bar.value=_n.value
	_n=who.getStat("fatigue")
	fatigue_bar.max_value=_n.ul
	fatigue_bar.value=_n.value
	_n=who.getStat("lust")
	lust_bar.max_value=_n.ul
	lust_bar.value=_n.value

func on_effect_update(who:Character,effectID:String):
	var _item=who.effects.getItemByID(effectID)
	if(_item):
		listEffects.addOrReplaceItem(_item)
	else:
		listEffects.removeItem(effectID)

# call this once after creating the widget
func on_effect_update_all(who:Character):
	Util.delete_children(listEffects)
	for _item in who.effects.getItems():
		listEffects.addOrReplaceItem(_item)

func on_bust_update(who:Character):
	characterName=who.getName()
	%icon.texture_normal=load(who.getBustImage())
