extends "res://ui/navigation_scene.gd"


const States = {IDLE=1,DIGGING = 2, DIG_FAILED=3 }

func _read()-> void:
	pass

func on_button(i:int):
	if state==States.DIGGING:
		digging(i)
	pass



func _on_bt_home_pressed() -> void:
	navigate_home()
	pass


func _on_bt_explore_pressed() -> void:
	msg=msg_scn.instantiate()
	if(state==0):
		show_Intro()
	else:
		Global.main.doTimeProcess(30*60)
		state=States.DIGGING
		msg.text= "There is something sparkling between seasshells"
		msg.config_bt(0,"Ignore it")
		msg.config_bt(1,"Dig it out")
		show_msg()

func show_Intro():
	state=States.IDLE
	msg=msg_scn.instantiate()
	msg.text= "you wake up at the beach"
	show_msg()

func digging(i:int):
	Global.main.doTimeProcess(30*60)
	if i==1:
		msg=msg_scn.instantiate()
		state=States.DIG_FAILED
		msg.text= "There is nothing"
		show_msg()
	
