extends DialogueEngine

enum { DEFAULT_BRANCH = 0, GAVE_SHELL, NO_GAVE_SHELL }


func _setup() -> void:
	var first_entry : DialogueEntry = add_text_entry("A shell a shell a kingdom for a seashell !", DEFAULT_BRANCH)
	var option_id_1 : int = first_entry.add_option("I have no seashell.")
	var option_id_1_entry : DialogueEntry = add_text_entry("Sorry little crab but I dont have any shell for you", NO_GAVE_SHELL)
	first_entry.set_option_goto_id(option_id_1, option_id_1_entry.get_id())
	var option_id_2 : int = first_entry.add_option("Give seashell.")
	var option_id_2_entry : DialogueEntry = add_text_entry("Here you go little guy", GAVE_SHELL)
	first_entry.set_option_goto_id(option_id_2, option_id_2_entry.get_id())
	
	#first_entry.set_goto_id(add_text_entry("how gotos work against different branch IDs", DIFFERENT_BRANCH_TWO).get_id())
	var default_topic : DialogueEntry = add_text_entry("I need to leave")
	
	add_text_entry("But I waana have shell !", NO_GAVE_SHELL).set_goto_id(default_topic.get_id())
	
	add_text_entry("Thank you so much. Here let me give you this.", GAVE_SHELL).set_goto_id(default_topic.get_id())
