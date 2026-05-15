class_name BarStat extends Control

@export var text:String:
	set(v):
		text=v
		$Label.text=text # +"   "+ str(value)+"/"+str(max_value)
		#TODO display numbers on big bars?

func get_max_value()->float:
	return $bar.max_value

func setTint(under:Color,progress:Color):
	$bar.tint_under=under
	$bar.tint_progress=progress

func setValue(v:float,maxv:float):
	$bar.max_value=maxv
	var tw = create_tween()
	tw.tween_property($bar, "value", v, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	#$bar.value=v

func adjustHeight(max2:float):
	var maxH=self.size.x
	$bar.scale.x=maxH/$bar.size.x*$bar.max_value/max2
