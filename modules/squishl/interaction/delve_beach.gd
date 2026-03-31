extends DialogueEngine

# this is not a dialog but entry of a complex scene
# - tell the player that he is moving into the water
# - start a fight
# - return here
# - if he is still alive move to next fight, else throw him out

enum { DEFAULT_BRANCH = 0 }

var meta:Dictionary={}

func _setup() -> void:
	var first_entry : DialogueEntry
	first_entry=add_text_entry("There is something in the water !", DEFAULT_BRANCH)
	first_entry.set_metadata_data(meta)
	
	var second_entry : DialogueEntry
	second_entry=add_text_entry("There is something in the water !", DEFAULT_BRANCH)
	second_entry.set_metadata_data(meta)
	second_entry.set_metadata("fight",1)
	
	self.entry_visited.connect(__react)

func __react(entry : DialogueEntry):
	var _item=entry.get_metadata("fight",0)
	if(_item==1):
		Global.pc.inventory.removeItemID("seashell")
		Global.pc.inventory.addItemID("gel_green")
	pass
