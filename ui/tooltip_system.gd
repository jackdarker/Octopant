extends CanvasLayer

# to make use of the tooltip you have to call showTooltip onMouseEnter
# and hideTooltip onMouseLeave

@onready var tooltip = $TooltipDisplay

var nodeRef:WeakRef

func _ready() -> void:
	resetTooltips()

func showTooltip(theControl, title: String, text: String, _showBelow: bool = false, wideTooltip: bool = false):
	tooltip.is_wide=wideTooltip
	tooltip.showBelow=_showBelow
	tooltip.set_text(title, text)
	tooltip.is_active=true
	nodeRef = weakref(theControl) if theControl else null


func hideTooltip(theNodeRef):
	if(getRefNode() && theNodeRef != getRefNode()):
		return

	nodeRef = null
	tooltip.is_active=false

func resetTooltips():
	nodeRef = null
	tooltip.is_active=false
	

func _process(_delta):
	if(nodeRef == null):
		return
	var theNode = nodeRef.get_ref()
	if(!theNode || !theNode.is_visible_in_tree()):
		resetTooltips()


func getRefNode():
	return nodeRef.get_ref() if nodeRef else null
