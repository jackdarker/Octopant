class_name CombatAIBase extends Node

const SKILL_SPECIAL:="Skill_Special"
const SKILL_ATTACK:="Skill_Attack"
const SKILL_BLOCK:="Skill_Block"
const SKILL_TRIP:="Skill_Trip"
const SKILL_STEADY:="Skill_Steady"
const SKILL_TEASE:="Skill_Tease"
const SKILL_FOCUS:="Skill_Focus"

const SKILL_GROPE:="Skill_Grope"
const SKILL_SPECIALGRAB:="Skill_SpecialGrab"

const SKILL_STRUGGLE:="Skill_Struggle"
const SKILL_BREAKFREE:="Skill_Breakfree"
const SKILL_SUBMIT:="Skill_Submit"



## support class
class CombatSkillResult extends Result:
	var skill:Skill
	var targets:Array[Character]
	static func create(ok,msg)->CombatSkillResult:
		var _n=CombatSkillResult.new()
		_n.OK=ok
		_n.Msg=msg
		return _n

var wrefCharacter:WeakRef=null
var char:Character:
	set(value):
		wrefCharacter=weakref(value)
	get:
		return(wrefCharacter.get_ref() if wrefCharacter else null)

var wrefScene:WeakRef=null
var scene:CombatScene:
	set(value):
		wrefScene=weakref(value)
	get:
		return(wrefScene.get_ref() if wrefScene else null)

var combat_beh:=["Skill_Attack","Skill_Attack","Skill_Trip"]
var grapple_beh:=["Skill_Grope","Skill_Grope"]
var moves=combat_beh.duplicate()

var combat_flavour:CombatFlavour

func battleInit(combatScene):
	scene=combatScene
	combat_flavour=char.combat_scene.new()
	combat_flavour.enemy=char
	combat_flavour.player=scene.actor

## override this; default will just choose a random target and try to find a random Attack-Skill to use
func selectCombatSkill(enemyParty:Array[Character],_ownParty:Array[Character])->CombatSkillResult:
	var _res:CombatSkillResult=CombatSkillResult.create(true,"")
	# choose random from moveset; if all moves done use special; after special restart moveset
	var skillid:String=moves.pop_at(randi_range(0,moves.size()-1))
	if(scene.mode==scene.MODE.grapple):
		if(skillid=="Skill_SpecialGrab"):
			moves=grapple_beh.duplicate()
			#Inventory.filter_by_tag(char.skills.getItems(),[SkillTagEnum.Special])
		elif(moves.size()==0):
			moves=["Skill_SpecialGrab"]
	else:
		if(skillid=="Skill_Special"):
			moves=combat_beh.duplicate()
		elif(moves.size()==0):
			moves=["Skill_Special"]

	_res.skill=char.skills.getItemByID(skillid)
	return _res
