extends DialogueEngine

enum { DEFAULT_BRANCH = 0, TALK, FUCK }

var meta:Dictionary={}
const avatar_player = "res://assets/images/icons/ic_unknown.svg"
const avatar_lutes = "res://assets/images/chars/lutes.png"

func _setup() -> void:
	meta["char1"]=avatar_player
	meta["char2"]=avatar_lutes
		
	var first_entry : DialogueEntry
	first_entry=add_text_entry("Hey, you again !", DEFAULT_BRANCH)
	first_entry.set_metadata_data(meta)
	var option_id_1 : int = first_entry.add_option("Oh hello. Can we talk?")
	var option_id_2 : int = first_entry.add_option("Wanna fuck?.")
	var option_id_3 : int = first_entry.add_option("I am in a hurry..")
	
	var option_id_1_entry : DialogueEntry = add_text_entry("You talk about this and that", TALK)
	var option_id_2_entry : DialogueEntry = add_text_entry("Sorry, not in the mood", FUCK)
	var default_topic : DialogueEntry = add_text_entry("I need to leave")
	first_entry.set_option_goto_id(option_id_1,option_id_1_entry.get_id())
	first_entry.set_option_goto_id(option_id_2,option_id_2_entry.get_id())
	first_entry.set_option_goto_id(option_id_3,default_topic.get_id())
	add_text_entry("You feel your mood lighten up somewhat.",TALK)
	
	add_text_entry("OK, no problem....",FUCK)
		
	self.entry_visited.connect(__react)

func __react(entry : DialogueEntry):
	pass
