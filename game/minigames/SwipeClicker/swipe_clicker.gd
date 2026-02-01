extends Control

# 
# this is inspired by the BDCC ClickAtTheRightTime

signal minigameCompleted(result)

var ingame = false
var time = 0.0
var cursorSpeed = 1.0
var timer = 10.0
var timeLeft = timer
var difficulty = 5.0
var freeze = false
var goldenZoneVisible = false
var isBlindFoldedVersion = false

var hasAdvancedPerk = true
var hardStruggleEnabled = true
var perfectStreak = 0
var howMuchForPerfect = 0.25

var failZoneData = []
var tween:Tween

func _ready():
	setIngame(false)
	#setGoldenZoneVisible(false)
	#setHardStruggleEnabled(false)
	setDifficulty(2)
	#setIsBlindfolded(false)
	%bt_start.grab_focus()
	#minigameCompleted.connect(setIngame.bind(false).unbind(1))
	minigameCompleted.connect(func(x):
		self.freeze=true)

func _process(delta):
	if(isBlindFoldedVersion && !hardStruggleEnabled):
		delta /= 2.0
	
	if(ingame && !freeze):
		if(timeLeft > 0 && (timeLeft - delta) <= 0):
			minigameCompleted.emit(_calcFinalScore())
		time += delta
		timeLeft -= delta
		
		#if(hardStruggleEnabled):
			#processFatalZones()
			#moveRedZone()
		
		var newPosition = _getCursorPosition();
		_setCursorPosition(newPosition)
		_setTimeBar(timeLeft / timer)

		#var flatStyle:StyleBoxFlat = $GameScreen/Panel.get_stylebox("panel")
		#if(isBlindFoldedVersion):
		#	flatStyle.bg_color = Color.red
		#	
		#	var score = _getScore()
		#	if(score >= 1000.0):
		#		flatStyle.bg_color = Color("ffe300")
		#	elif(score >= 1.0):
		#		flatStyle.bg_color = Color("990000")
		#	elif(score > 0.0):
		#		flatStyle.bg_color = Color("990000").darkened(1.1 - score)
		#	else:
		#		flatStyle.bg_color = Color.black
		#else:
		#	flatStyle.bg_color = Color.black
	
	if(Input.is_action_just_pressed("ui_accept")):
		if(!ingame):
			pass
		else:
			_doCommitClick()

func setDifficulty(level):
	if level < 1.0:
		level = 1.0
	
	timer = 3.4 + 20.0/(2.0 + level)
	timeLeft = timer
	cursorSpeed = 1.2 + level/8.0
	difficulty = level
	_generateZone(difficulty)
	#generateFatalZone(difficulty)

func _setCursorPosition(pos:float):
	%cursor.anchor_left = pos
	%cursor.anchor_right = pos

func _getCursorPosition():
	return (sin(pow(time * cursorSpeed, 1.2)) + 1.0) / 2.0

func _getScore():
	var cursorPostion = _getCursorPosition()
	#if isFatal(cursorPostion):
	#	return -1.0
	#if(goldenZoneVisible && cursorPostion >= goldenZone.anchor_left && cursorPostion <= goldenZone.anchor_right):
	#	return 10000.0
	if(cursorPostion >= %good.anchor_left && cursorPostion <= %good.anchor_right):
		return 1.0
	#if(cursorPostion >= orangeZone.anchor_left && cursorPostion <= redZone.anchor_left):
	#	var shiftedPos = cursorPostion - orangeZone.anchor_left
	#	var diff = (redZone.anchor_left - orangeZone.anchor_left)
	#	if(diff > 0.01):
	#		return shiftedPos / diff
			
	#if(cursorPostion >= redZone.anchor_right && cursorPostion <= orangeZone.anchor_right):
	#	var shiftedPos = cursorPostion - redZone.anchor_right
	#	var diff = (orangeZone.anchor_right - redZone.anchor_right)
	#	if(diff > 0.01):
	#		return 1.0 - shiftedPos / diff
	
	return 0.0

func _calcFinalScore():
	var result = {"score":0.0,"failHard":false,"instantUnlock":false}
	var theScore:float = _getScore()
		
	if theScore < 0.0:
		result.score = 0.0
		result.failedHard = true
		return result
	if theScore >= 1000.0:
		result.score = 1.0
		result.instantUnlock = true
		return result

	if(theScore > 0.0 && theScore < 1.0 && hardStruggleEnabled):
		theScore /= 2.0

	if(hasAdvancedPerk && perfectStreak > 0):
		theScore = 1.0 + howMuchForPerfect * (perfectStreak - 1) + theScore * howMuchForPerfect
	
	result.score = theScore
	return result

func _setTimeBar(val):
	%bar_time.value = clamp(val, 0.0, 1.0)

func setIngame(newingame):
	ingame = newingame
	if(!ingame):
		$GameUI.visible = false
		$StartUI.visible = true
	else:
		$GameUI.visible = true
		$StartUI.visible = false

func _doCommitClick():
	if(freeze):
		return
	
	if(hasAdvancedPerk):
		var theScore = _getScore()
		if(theScore >= 1.0 && theScore <= 2.0):
			perfectStreak += 1
			timeLeft += 1.0
			timeLeft = min(timer, timeLeft)
			
			#%streakLabel.text = "Perfect Streak: "+str(perfectStreak)+" (+"+str(Util.roundF(howMuchForPerfect*perfectStreak*100.0, 1))+"%)"
			#if tween:
			#	tween.kill()
			#tween = create_tween()
			#tween.tween_method(self, "setStreakColor", Color.red, Color.white, 0.2)
			# reset pos
			_generateZone(difficulty)
			%lbl_score.text= str(_calcFinalScore().score)
			return
		
	
	#freeze = true
	#yield(get_tree().create_timer(0.5), "timeout")
	#freeze = false
	%lbl_score.text= str(_calcFinalScore().score)
	minigameCompleted.emit( _calcFinalScore())

func _generateZone(thedifficulty = 1.0):
	var zonePos =  randf()
	var zoneSize = 0.005 + 1.0/(11.0 + thedifficulty * 2.0)
	_setZonePosition(%good,zonePos,zoneSize)
	var zoneOrangeSize = 0.1 + 1.0/(2.0 + thedifficulty)
	

func _setZonePosition(zone:Node, pos:float, size:float):
	zone.anchor_left = clamp(pos - size, 0.0, 1.0)
	zone.anchor_right = clamp(pos + size, 0.0, 1.0)

func _on_game_gui_input(event):
	if(event is InputEventMouseButton):
		if(event.pressed && !freeze):
			_doCommitClick()

func _on_bt_start_pressed() -> void:
	setIngame(true)
