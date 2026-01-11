extends Effect



func _init():
	ID="eff_nausea"

func processTime(_delta:int):
	var _now=timeDelta+_delta
	var _time 
	_time=_now- self.timeLast
	if(_time>=3600):	#tick every 1h
		character.statuslist.getItemByID(StatEnum.Fatigue).modify(-10)
		self.timeLast=_now+self.timeLast
		self.timeDelta=0
	
	_time=self.timeLast-self.timeStart
	if _time>=duration:
		destroyMe()
		return
	

func onApply():
	self.duration=8*60*60
