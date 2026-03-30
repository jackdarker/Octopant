class_name Result extends Object

var OK:bool=false
var Msg:String=""

static func create(ok,msg)->Result:
	var _n=Result.new()
	_n.OK=ok
	_n.Msg=msg
	return _n

func setRes(ok,msg):
	OK=ok
	Msg=msg

func And(res2:Result)->Result:
	return Result.create(self.OK && res2.OK, self.Msg+"\n"+res2.Msg)
