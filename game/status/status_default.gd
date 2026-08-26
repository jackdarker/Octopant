class_name StatusDefault extends Object

##  special Status with modifiers


class StatStrength extends Status:
	func _init():
		self.ID=StatEnum.Strength
		
	func updateModifier():
		if(!modifys.has(StatEnum.Pain)):
			modifys.push_back(StatEnum.Pain)
		parent.addModifier(StatEnum.Pain,{"ID":ID, "lmax": parent.getItemByID(ID).value*1.5});
		
class StatAgility extends Status:
	func _init():
		self.ID=StatEnum.Agility
		
	func updateModifier():
		if(!modifys.has(StatEnum.Fatigue)):
			modifys.push_back(StatEnum.Fatigue)
		parent.addModifier(StatEnum.Fatigue,{"ID":ID, 
		"lmax": parent.getItemByID(ID).value*1.5});
		
class StatIntellect extends Status:
	func _init():
		self.ID=StatEnum.Intellect
		
	func updateModifier():
		if(!modifys.has(StatEnum.Insanity)):
			modifys.push_back(StatEnum.Insanity)
		parent.addModifier(StatEnum.Insanity,{"ID":ID, "lmin": parent.getItemByID(ID).value*(-1.5),"lmax": parent.getItemByID(ID).value*1.5});
		
