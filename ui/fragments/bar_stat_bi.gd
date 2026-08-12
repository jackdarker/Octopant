class_name BarStatBi extends BarStat

# a bargraph that can show also a negative value

func get_max_value()->float:
	return %barNeg.max_value+%barPos.max_value

func setTint(under:Color,progress:Color):
	%barNeg.tint_under=under
	%barNeg.tint_progress=progress
	%barPos.tint_under=under
	%barPos.tint_progress=progress

func setValue(v:float,maxv:float):
	%barNeg.max_value=maxv
	%barPos.max_value=maxv
	var tw = create_tween()
	if(v>=0):
		tw.tween_property(%barPos, "value", v, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		#%barPos.value=v
		%barNeg.value=0.0
	else:
		%barPos.value=0.0
		tw.tween_property(%barNeg, "value", v*-1.0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		#%barNeg.value=v*-1.0

func adjustHeight(max2:float):
	var maxH=self.size.x
	$HBoxContainer.scale.x=maxH/($HBoxContainer.size.x)*(%barPos.max_value+%barNeg.max_value)/max2

func _on_mouse_entered() -> void:
	Global.toolTip.showTooltip(self,text,str(%barNeg.max_value)+"<"+str(max(%barNeg.value,%barPos.value))+"<"+str(%barPos.max_value))
