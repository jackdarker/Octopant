class_name CombatSetup extends Object

var canFlee:bool=true
var location:String="Unknown"
var background:Texture=null

var playerParty:Array[Character]=[]
var enemyParty:Array[Character]=[]

var onStart:Callable = func():pass			#hook to display battle intro
var onMoveSelect:Callable = func():pass		
var onVictory:Callable = defaultVictory			#hook to display battle outro
var onDefeat:Callable = defaultDefeat			#hook to display battle outro
var onSubmit:Callable = defaultDefeat			#hook to display battle outro
var onFlee:Callable = defaultFlee			#hook to display battle outro

static func defaultVictory(scene:CombatScene):
	Global.hud.clearOutput()
	Global.hud.clearInput()
	Global.hud.say("You have won this fight")	#todo fetchloot
	Global.hud.addButton("Next","",func():Global.main.removeScene(scene))

static func defaultDefeat(scene:CombatScene):
	Global.hud.clearOutput()
	Global.hud.clearInput()
	Global.hud.say("You lost")
	Global.hud.addButton("Next","",func():Global.main.removeScene(scene))

static func defaultFlee(scene:CombatScene):
	Global.hud.clearOutput()
	Global.hud.clearInput()
	Global.hud.say("You succesfully escaped.")
	Global.hud.addButton("Next","",func():Global.main.removeScene(scene))
