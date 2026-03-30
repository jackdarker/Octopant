class_name BarStat extends Control

@export var text:String:
	set(v):
		text=v
		$Label.text=text # +"   "+ str(value)+"/"+str(max_value)
		#TODO display numbers on big bars?

var max_value:float:
	get():
		return $bar.max_value

func setTint(under:Color,progress:Color):
	$bar.tint_under=under
	$bar.tint_progress=progress

func setValue(v:float,max:float):
	$bar.max_value=max
	$bar.value=v
	#self.text=self.text

func adjustHeight(max2:float):
	var maxH=self.size.y
	$bar.scale.y=maxH/$bar.size.y*$bar.max_value/max2
