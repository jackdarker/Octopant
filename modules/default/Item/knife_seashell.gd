extends ItemBase

func _init():
	super()
	id="knife_seashell"

func getTags()->Array:
	return [ITEM_TAG.Tool_Cut]
