extends CanvasLayer

# implements tooltip and notification-system
# to make use of the tooltip you have to call showTooltip onMouseEnter and hideTooltip onMouseLeave
# to use notification call showNotification; notifications will decease after time
# notifications stack in top-right corner and slide in/out to right direction

signal notificationShown(panel)
signal request_close(panel)
@export var spacing: int = 8	#separation of notifications
@export var margin: int = 8		#separation between notification and screenborder
@export var display_time: float = 4.0	#TODO scale time with text-length
@export var slide_time: float = 0.25

@onready var tooltip = $TooltipDisplay
@onready var notificationStack = $Notifications

var NotificationScene: PackedScene = preload("res://ui/notification_display.tscn")

var tooltipParentRef:WeakRef

func _ready() -> void:
	resetTooltips()
	notificationShown.connect(_on_notification_shown)
	request_close.connect(_on_notification_request_close)

#region tooltip
func showTooltip(theControl, title: String, text: String, _showBelow: bool = false, wideTooltip: bool = false):
	tooltip.is_wide=wideTooltip
	tooltip.showBelow=_showBelow
	tooltip.set_text(title, text)
	tooltip.is_active=true
	tooltipParentRef = weakref(theControl) if theControl else null


func hideTooltip(theNode):
	if(theNode != getTooltipParent()):
		return
	tooltipParentRef = null
	tooltip.is_active=false

func resetTooltips():
	tooltipParentRef = null
	tooltip.is_active=false
	

func _process(_delta):
	#remove tooltip if parent is gone
	var theNode = getTooltipParent()
	if(!theNode || !theNode.is_visible_in_tree()):
		resetTooltips()


func getTooltipParent():
	return tooltipParentRef.get_ref() if tooltipParentRef else null
#endregion

#region notification

func showNotification(title: String, message: String, icon: Texture2D = null, time: float = 4.0):
	var panel:NotificationDisplay = NotificationScene.instantiate()
	panel.set_size(Vector2(10,10))
	panel.title=title 
	panel.message=message
	
	var y = margin
	for p in notificationStack.get_children():	#TODO if multiple notifications added at same time, they have huge spacing, why?
		y += p.size.y + spacing
	notificationStack.add_child(panel)
	var start_pos = Vector2( panel.get_viewport_rect().size.x+10, y )
	panel.position = start_pos
	
	panel.request_close.connect(_on_notification_request_close)
	_play_notification.call_deferred(panel)

func _play_notification(panel:NotificationDisplay):
	var end_pos = Vector2( panel.get_viewport_rect().size.x -panel.size.x-margin, panel.position.y )
	panel.size.y = 0	#the label would not shrink back otherwise
	panel.size.x = 0
	var tw = create_tween()
	tw.tween_property(panel, "position", end_pos, slide_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tw.finished
	panel.size.y = 0	#the label would not shrink back otherwise
	panel.size.x = 0
	notificationShown.emit(panel)
	panel.hideTimer.one_shot=true
	panel.hideTimer.timeout.connect(_hide_notification.bind(panel))
	panel.hideTimer.start(display_time)
	

func _hide_notification(panel)->void:
	var end_pos = Vector2( panel.get_viewport_rect().size.x + panel.size.x + 10, panel.position.y )
	var tw = create_tween()
	tw.tween_property(panel, "position", end_pos, slide_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tw.finished
	request_close.emit(panel)

func _on_notification_request_close(panel):
	for n in notificationStack.get_children():
		if n==panel: 
			notificationStack.remove_child(n)
			n.queue_free()
			break
	_reposition_notifications()
	
func _on_notification_shown(panel):
	pass#_reposition_notifications()

func _reposition_notifications():
	# place panels stacked downward from top with spacing
	var y = margin
	for p in notificationStack.get_children():
		var target = Vector2( p.get_viewport_rect().size.x - p.size.x - margin, y )
		# animate shift using Tween
		var tw = create_tween()
		tw.tween_property(p, "position", target, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		y += p.size.y + spacing
	
#endregion
