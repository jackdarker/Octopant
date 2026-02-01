class_name SkillCost extends Node

# a structure that defines the cost you have to spent to use a skill
var fatigue:float=0

func canPay(_user:Character)->Result:
	var _res=Result.create(true,"")
	if(_user.getStat(StatEnum.Fatigue).value<fatigue):
		_res.OK=false
		_res.Msg+=" to fatigued"
	return(_res)

func pay(_user:Character):
	if(fatigue>0):
		_user.getStat(StatEnum.Fatigue).modify(-1*fatigue)


func asText()->String:
	var msg=""
	if(fatigue>0):
		msg+=str(fatigue)+" fatigue"
	if(msg==""):
		msg = "without cost"
	else:
		msg = "requires " +msg;
	return(msg);
