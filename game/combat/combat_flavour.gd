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

## combatScene calls this to generate description for display when player is hit by enemy
## (but not when player countered the enemy)
# return 0 - nothing defined; -> generate generic message
# return 1 - the function prints some text; -> continue with battle
func hitByEnemy(skill_Player:Skill,skill_Enemy:Skill)->int:
	return 0
