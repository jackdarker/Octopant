class_name Result extends Object

var OK:bool=false
var Msg:String=""

static func create(ok,msg)->Result:
	var _n=Result.new()
	_n.OK=ok
	_n.Msg=msg
	return _n
