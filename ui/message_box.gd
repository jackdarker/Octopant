extends Panel

@export var text:String = "Choose something"
@export var bt1Text:String ="Next"
@export var bt2Text:String =""
@export var bt3Text:String =""
@export var bt4Text:String =""
@export var bt1Enabled:int = 1
@export var bt2Enabled:int = 0
@export var bt3Enabled:int = 0
@export var bt4Enabled:int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CenterContainer/Panel/MarginContainer/VBoxContainer/RichTextLabel.text=text
	$CenterContainer/Panel/MarginContainer/VBoxContainer/bt1.text=bt1Text
	$CenterContainer/Panel/MarginContainer/VBoxContainer/bt2.text=bt2Text
	$CenterContainer/Panel/MarginContainer/VBoxContainer/bt2.visible=(bt1Enabled==1)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_bt_pressed() -> void:
	close()
	pass # Replace with function body.

func close()-> void:
	close_deffered.call_deferred()
	
func close_deffered():
	self.queue_free()
