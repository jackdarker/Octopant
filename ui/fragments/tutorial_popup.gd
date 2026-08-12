class_name TutorialPopup extends CanvasLayer
signal closed()

@onready var Overlay = $"."

func _ready() -> void:
	# allow clicking overlay to close optionally:
	pass#Overlay.mouse_filter = Control.MOUSE_FILTER_STOP

func setup_from_dict(dict: TutorialData) -> void:
	%Title.text = dict.title
	%Content.text = dict.text
	if dict.icon_path != "":
		var tex = load(dict.icon_path)
		if tex: 
			%Icon.texture = tex
		else: 
			%Icon.visible = false
	else:
		%Icon.visible = false
	#var show_once :bool= dict.get("show_once", true)
	#DontShowAgain.visible = show_once
	#DontShowAgain.pressed = false
	# Anchor handling
	var anchor = dict.anchor
	if anchor != "center":
		anchor_to_node(anchor)
	# Auto-close conditions (optional)
	#if dict.has("auto_close") and dict.auto_close:
	#	var delay = float(dict.get("auto_close_delay", 3.0))
	#	yield(get_tree().create_timer(delay), "timeout")
	#	_on_close_pressed()

func anchor_to_node(node_path: String) -> void:
	# If path refers to a node in scene tree, position popup near it (screen coords)
	var node = get_node_or_null(node_path)
	#if node and node is Control:
	#	var global_pos = node.get_global_position()
	#	global_position = global_pos + Vector2(0, node.rect_size.y + 8)
	#else:
		# attempt to find by name in current scene
	#	var root = get_tree().get_current_scene()
	#	if root:
	#		var found = root.get_node_or_null(node_path)
	#		if found and found is Control:
	#			global_position = found.get_global_position() + Vector2(0, found.rect_size.y + 8)

func _on_bt_close_pressed() -> void:
	# If checkbox checked, tell manager to mark not to show again
	#if DontShowAgain.visible and DontShowAgain.pressed:
		# manager will pick this up because show_once is read from data;
		# here we emit closed and manager already recorded shown=true

	emit_signal("closed")
