class_name CombatSetup extends Object

var canFlee:bool=true
var location:String="Unknown"
var background:Texture=null

var playerParty:Array[Character]=[]
var enemyParty:Array[Character]=[]

var onStart:Callable = func():{}
var onMoveSelect:Callable = func():{}
