class_name HudCenterDefault extends Control


var text_bullet = preload("res://ui/fragments/text_bullet.tscn")

func _ready() -> void:
	show_picture_center(null)
	show_picture_left(null)
	show_picture_right(null)
	pass

## who is dictionary of formating {"bgcolor":#49c9}	
func say(text,who:Dictionary={}):
	#msg.append_text("\n"+text)
	var label = text_bullet.instantiate()
	label.set_use_bbcode(true)
	label.set_fit_content(true)
	if(who.has("bgcolor")):
		text="[bgcolor=#"+who.bgcolor.to_html()+"]"+text+"[/bgcolor]"
	label.set_text(text)
	%msg.add_child(label)
	await get_tree().process_frame
	if(label):  #there might be occasions where clearOutput() is a called before the frame and label is already destroyed
		%msg.get_parent().ensure_control_visible(label)

func show_picture_center(_texture:Texture):
	%pictureC.texture=_texture
	%pictureC.visible=true if _texture!=null else false

func show_picture_left(_texture:Texture):
	%pictureL.texture=_texture
	%pictureL.visible=true if _texture!=null else false

func show_picture_right(_texture:Texture):
	%pictureR.texture=_texture
	%pictureR.visible=true if _texture!=null else false

func clearOutput():
	for child in %msg.get_children():
		%msg.remove_child(child)
		child.queue_free()

# hide buttons
func clearInput():
	for bt:BaseButton in %buttons.get_children():
		bt.disabled=true
		bt.visible=false
		bt.text=""
		var pressed=bt.pressed.get_connections()			#Todo make lambda
		for evt in pressed:
			bt.pressed.disconnect(evt.callable)
		var _mouse_entered=bt.mouse_entered.get_connections()
		for evt in _mouse_entered:
			bt.mouse_entered.disconnect(evt.callable)
		var _mouse_exited=bt.mouse_exited.get_connections()
		for evt in _mouse_exited:
			bt.mouse_exited.disconnect(evt.callable)
	pass

func addButton(text:String,tooltip:String,code:Callable,check=null):
	for bt:BaseButton in %buttons.get_children():	#TODO more...page if to many buttons
		#TODO favour undisabled button against disabled
		var tooltip2=tooltip
		if(!bt.visible): #choose the next unused button
			bt.text=text
			#bt.tooltip_text=tooltip
			bt.disabled=false
			if(check):
				var _res:Result=(check as Callable).call()
				if !_res.OK:
					bt.disabled=true
				tooltip2+=_res.Msg
			bt.visible=true
			bt.pressed.connect(code)
			bt.mouse_entered.connect(Global.toolTip.showTooltip.bind(bt,text,tooltip2))
			bt.mouse_exited.connect(Global.toolTip.hideTooltip.bind(bt))
			break
	pass
