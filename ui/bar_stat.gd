extends TextureProgressBar

@export var text:String:
	set(v):
		text=v
		$Label.text=text # +"   "+ str(value)+"/"+str(max_value)
		#TODO display numbers on big bars?

func setValue(v:float,max:float):
	self.value=v
	self.max_value=max
	#self.text=self.text
