class_name BarStatBi extends BarStat

# a bargraph that can show also a negative value

func get_max_value()->float:
	return %barNeg.max_value+%barPos.max_value

func setTint(under:Color,progress:Color):
	%barNeg.tint_under=under
	%barNeg.tint_progress=progress
	%barPos.tint_under=under
	%barPos.tint_progress=progress

func setValue(v:float,max:float):
	%barNeg.max_value=max
	%barPos.max_value=max
	if(v>=0):
		%barPos.value=v
		%barNeg.value=0.0
	else:
		%barPos.value=0.0
		%barNeg.value=v*-1.0

func adjustHeight(max2:float):
	var maxH=self.size.x
	$HBoxContainer.scale.x=maxH/($HBoxContainer.size.x)*(%barPos.max_value+%barNeg.max_value)/max2
