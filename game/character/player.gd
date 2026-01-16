extends Character
class_name Player


func post_sleep():
	getStat(StatEnum.Pain).modify(-99999)
	getStat(StatEnum.Fatigue).modify(-99999)
	GlobalRegistry.createEffect("eff_arousable").applyTo(self)
	
