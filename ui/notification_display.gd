class_name NotificationDisplay extends PanelContainer

signal request_close(panel)

@export var icon: Texture2D
@export var title:String ="MyTitle"
@export var message:String ="My message"

@onready var _title:RichTextLabel=$Panel/VBoxContainer/lb_header
@onready var _body:RichTextLabel=$Panel/VBoxContainer/lb_body
@onready var hideTimer:Timer = $hideTimer	#Note hideTimer is used by Notification-System

func _ready()->void:
	_show_notification()

func _show_notification():
	_title.text = title	#.capitalize()
	_body.text=message
	size.y = 0	#the label would not shrink back otherwise
	size.x = 0

# TODO click on Notif. to dismiss
func _on_close_pressed():
	hideTimer.stop()
	request_close.emit(self)
