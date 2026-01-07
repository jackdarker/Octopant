extends DialogueEngine

enum { DEFAULT_BRANCH = 0, GAVE_SHELL, NO_GAVE_SHELL }

var meta:Dictionary={}
const avatar_player = "res://assets/images/icons/ic_unknown.svg"
const avatar_crab = "res://assets/images/chars/spider1.svg"

func _setup() -> void:
	meta["char1"]=avatar_player
	meta["char2"]=avatar_crab
	
	var first_entry : DialogueEntry
	first_entry=add_text_entry("A shell a shell a kingdom for a seashell !", DEFAULT_BRANCH)
	first_entry.set_metadata_data(meta)
	
	
	var condition_entry = add_conditional_entry(func(): return Global.pc.inventory.hasItemID("seashell"))
	var if_true : DialogueEntry = add_text_entry("I feel you have some seashell with you")
	var if_false : DialogueEntry = add_text_entry("Bring some seahshell!", NO_GAVE_SHELL)
	condition_entry.set_condition_goto_ids(if_true.get_id(), if_false.get_id())
	
	
	var option_id_1 : int = if_true.add_option("I have no seashell.")
	var option_id_1_entry : DialogueEntry = add_text_entry("Sorry little crab but I dont have any shell for you", NO_GAVE_SHELL)
	if_true.set_option_goto_id(option_id_1, option_id_1_entry.get_id())
	var option_id_2 : int = if_true.add_option("Give seashell.")
	var option_id_2_entry : DialogueEntry = add_text_entry("Here you go little guy", GAVE_SHELL)
	if_true.set_option_goto_id(option_id_2, option_id_2_entry.get_id())

	var default_topic : DialogueEntry = add_text_entry("I need to leave")
	
	add_text_entry("But I waana have shell !", NO_GAVE_SHELL).set_goto_id(default_topic.get_id())
		
	var gave_shell_entry = add_text_entry("Thank you so much. Here let me give you this./n
		It squirts some green slime in front of you.", GAVE_SHELL)
	gave_shell_entry.set_goto_id(default_topic.get_id())
	gave_shell_entry.set_metadata("remove_item","seashell")
	gave_shell_entry.set_metadata("char2","res://assets/images/items/Gel_S_Green.svg")
	
	self.entry_visited.connect(__react)

func __react(entry : DialogueEntry):
	var _item=entry.get_metadata("remove_item","")
	if(_item!=""):
		Global.pc.inventory.removeItemID("seashell")
		Global.pc.inventory.addItemID("gel_green")
	pass
