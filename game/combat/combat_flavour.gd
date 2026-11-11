class_name CombatFlavour extends RefCounted


# - create an override for each of your mobs

var wrefPlayer:WeakRef=null
var player:Character:
	set(value):
		wrefPlayer=weakref(value)
	get:
		return(wrefPlayer.get_ref() if wrefPlayer else null)

var wrefEnemy:WeakRef=null
var enemy:Character:
	set(value):
		wrefEnemy=weakref(value)
	get:
		return(wrefEnemy.get_ref() if wrefEnemy else null)

## when player is hit by enemy (but not when player countered the enemy) 
## the combatScene calls this to generate description for display
## combatscene takes care of damage but you could add extra damage here
# return 0 - nothing defined; -> generate generic message
# return 1 - the function prints some text via Global.hud.say(); -> continue with battle
func hitByEnemy(skill_Player:Skill,skill_Enemy:Skill)->int:
	return 0

## when player is taken into grapple combatScene calls this to generate description for display
func intoGrapple()->int:
	return 0
	
## when player pushs free from grapple the combatScene calls this to generate description for display
func outofGrapple()->int:
	return 0
	
## when player lust at max the combatScene calls this to generate description for display
# - check scene.Mode if in Grapple or not
func orgasmActor()->int:
	return 0

func orgasmEnemy()->int:
	return 0
