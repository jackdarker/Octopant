class_name UI_EffectsList extends HFlowContainer

var effectIcon = preload("res://ui/ui_effect_icon.tscn")
@onready var list =  $"."

func _ready():
	$".".clearEffects()


func clearEffects():
	for item in list.get_children():
		list.remove_child(item)
		item.queue_free()


func removeItem(ID:String):
	for item in list.get_children():
		if item.ID==ID:
			list.remove_child(item)
			item.queue_free()


#TODO addOrReplaceMultipleItem
func addOrReplaceItem(effect:Effect):
	#if the effect is fully hidden we should remove it
	if effect.hidden == effect.HIDE.ALL:
		removeItem(effect.ID)
		return
	#replace...
	for item in list.get_children():
		if item.ID==effect.ID:
			item.setItem(effect)
			return
	#..or add
	var block = effectIcon.instantiate()
	block.setItem(effect)
	list.add_child(block)
	sortItems()

func sortItems():
	#TODO sort alphabetical? combatEffectsFirst?
	pass
