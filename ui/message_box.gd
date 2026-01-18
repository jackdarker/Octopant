extends Panel
class_name MessageBox

@export var text:String = "Choose something"
@export var bt1Text:String ="Next"
@export var bt2Text:String =""
@export var bt3Text:String =""
@export var bt4Text:String =""
@export var bt1Enabled:int = 1
@export var bt2Enabled:int = 1
@export var bt3Enabled:int = 1
@export var bt4Enabled:int = 1

var _buttonRefs:Array=[]

signal on_button(bt_id)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CenterContainer/Panel/MarginContainer/VBoxContainer/RichTextLabel.text=text
	_buttonRefs= [$CenterContainer/Panel/MarginContainer/VBoxContainer/bt1,
		$CenterContainer/Panel/MarginContainer/VBoxContainer/bt2,
		$CenterContainer/Panel/MarginContainer/VBoxContainer/bt3,
		$CenterContainer/Panel/MarginContainer/VBoxContainer/bt4]
	var i:int=0
	for bt in _buttonRefs:
		if i==0:
			bt.text=bt1Text
			bt.visible=(bt1Enabled==1) && bt.text!=""
		elif i==1:	
			bt.text=bt2Text
			bt.visible=(bt2Enabled==1) && bt.text!=""
		elif i==2:	
			bt.text=bt3Text
			bt.visible=(bt3Enabled==1) && bt.text!=""
		elif i==3:	
			bt.text=bt4Text
			bt.visible=(bt4Enabled==1) && bt.text!=""
		i=i+1
	
func _on_bt_pressed(bt_id) -> void:
	on_button.emit(bt_id)
	close()
	pass # Replace with function body.

func config_bt(id:int,_text:String,enabled:int=1,_tooltip:String=""):
	if id==0:
		bt1Text=text		#TODO connect to tooltip
		bt1Enabled=enabled
	elif id==1:	
		bt2Text=text
		bt2Enabled=enabled
	elif id==2:	
		bt3Text=text
		bt3Enabled=enabled
	elif id==3:
		bt4Text=text
		bt4Enabled=enabled

func close()-> void:
	close_deffered.call_deferred()
	
func close_deffered():
	self.queue_free()
