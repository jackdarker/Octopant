class_name UI_EffectIcon extends Control

var ID:String=""


func setItem(item:Effect):
	self.ID=item.getID()
	setTexture(item.getIcon())
	setColor(item.getIconColor())

func setColor(newcolor):
	self_modulate = newcolor

func setTexture(texture: String):
	$TextureRect.texture = load(texture)

#TODO tooltip; depends on .hidden
