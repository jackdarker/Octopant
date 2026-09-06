class_name AttackData extends Result

## describes an attack caused by a combatSkill
var critical:bool=false
var isTease:bool=false
var hitChance:float =50
var critChance:float =4	#TODO
var onHit = []    # [{ target: 'target', eff: [combatEffect]]
var onCrit = []
var onHitMsg:Callable
var onCritMsg:Callable

static func create(_OK:=true,_msg:="")->AttackData:
	var _res=new()
	_res.OK=_OK
	_res.Msg=_msg
	return _res
