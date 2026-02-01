class_name Skill extends ItemBase
#Note derived from Item so that we can reuse some stuff and also can use same Inventory-Type

var coolDown:int=0	#current cooldown-counter
var defCoolDown:int=0	#default start count
var startDelay:int=0	#delay after fight start
var cost:SkillCost

func _init():
	super()
	cost=SkillCost.new()
	
func canDo(_action:String,_target:Character)->Result:
	var res=Result.create(true,"")
	#TODO res=this.isValidStance()
	if(!res.OK): 
		return(res)
	#if(this.isSealed().OK) res={OK:false,msg:'skill sealed'}; 
	if(coolDown>0):
		res.setRes(false,str(coolDown)+" turns cooldown") 
	if(!res.OK):
		return(res)
	res=getCost().canPay(user);
	return (res);

#override this !
func previewAction(_action:String,_target:Character)->Result:
	var _res=Result.create(true,user.name +" will use "+ name +" on " + _target.name)
	return(_res)

func doAction(_action:String,_target:Character):
	getCost().pay(user)
	applyAction(_action,_target)
	coolDown=defCoolDown

# override this !
func applyAction(_action:String,_target:Character):
	#var _res=Result.create(true,user.name +" uses "+ name +" on " + _target.name)
	pass

func getCost()->SkillCost:
	return(cost)

func onCombatStart():
	coolDown=startDelay

func onTurnStart():
	coolDown=max(0,coolDown-1);

#this is used to filter possible targets for a skill
#the function returns a array of arrays containing the targets  
#f.e. [[dragon],[mole1,mole2]] to indicate that the skill can be used on dragon or both moles at same time
func targetFilter(targets):
	return targets
