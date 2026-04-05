extends VBoxContainer

@onready var pain_bar=$HBoxContainer/VBoxContainer/barPain
@onready var fatigue_bar=$HBoxContainer/VBoxContainer/barFatigue
@onready var insanity_bar=$HBoxContainer/VBoxContainer/barInsanity
@onready var lust_bar=$HBoxContainer/VBoxContainer/barLust
@onready var listEffects=$listEffects

var characterName:String="unknown":
	set(value):
		characterName=value
		%lbl_name.text=value

func _ready() -> void:
	pain_bar.text="pain"
	pain_bar.setTint(Color.LIGHT_CORAL,Color.CORAL)
	fatigue_bar.text="fatigue"
	fatigue_bar.setTint(Color.LIGHT_SKY_BLUE,Color.ROYAL_BLUE)
	insanity_bar.text="insanity"
	insanity_bar.setTint(Color.BURLYWOOD,Color.GOLDENROD)
	lust_bar.text="lust"
	lust_bar.setTint(Color.LIGHT_PINK,Color.HOT_PINK)
	_apply_heights()

func _on_size_changed():
	# reapply if container resized or style changes
	_apply_heights()

func _apply_heights():
	var bars = $HBoxContainer/VBoxContainer.get_children()
	var max2:=0.0
	for b in bars:
		if not b is BarStat:
			continue
		max2=max(max2,b.get_max_value())
	for b in bars:
		if b.has_method("adjustHeight"):
			b.adjustHeight(max2)

func on_stat_update(who:Character):
	on_bust_update(who)
	var _n=who.getStat("pain")
	pain_bar.setValue(_n.value,_n.ul)
	_n=who.getStat("fatigue")
	fatigue_bar.setValue(_n.value,_n.ul)
	_n=who.getStat("insanity")
	if(!_n):
		insanity_bar.visible=false
	else:
		insanity_bar.setValue(_n.value,_n.ul)
	_n=who.getStat("lust")
	lust_bar.setValue(_n.value,_n.ul)
	_apply_heights()

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
