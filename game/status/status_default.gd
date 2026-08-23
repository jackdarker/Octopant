class_name StatusDefault extends Object

##  special Status with modifiers

class StatStrength extends Status:
	func _init():
		self.ID="strength"
		
	func updateModifier():
		if(!modifys.has(StatEnum.Pain)):
			modifys.push_back(StatEnum.Pain)
		parent.addModifier(StatEnum.Pain,{"ID":'strength', "lmax": parent.getItemByID(StatEnum.Strength).value*1.5});
		
