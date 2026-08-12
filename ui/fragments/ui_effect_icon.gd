class_name UI_EffectIcon extends Control

var ID:String:
	get():
		return data.getID()
		
var data:Effect

func setItem(item:Effect):
	data=item
	setTexture(item.getIcon())
	setColor(item.getIconColor())
	

func setColor(newcolor):
	self_modulate = newcolor

func setTexture(texture: String):
	$TextureRect.texture = load(texture)

#TODO tooltip; depends on .hidden
func _on_mouse_entered() -> void:
	Global.toolTip.showTooltip(self,data.getName(),data.getDescription())

func _on_mouse_exited() -> void:
	Global.toolTip.hideTooltip(self)
