@tool
extends Node2D
class_name Graph2D

# Each connection is directed: from -> to
var connections: Array[Dictionary] = []  # [{ "from": NodePath, "to": NodePath }]

# Optional styling
@export var line_color: Color = Color(1, 0.8, 0.2)
@export var line_width: float = 3.0
@export var arrow_size: float = 10.0
@export var in_editor_draw: bool = true

func _ready() -> void:
	# Ensure we draw at runtime too
	queue_redraw()

#func _notification(what: int) -> void:
#	if what == NOTIFICATION_EDITOR_PROPERTY_CHANGED:
#		queue_redraw()

func add_connection(from_node: Node2D, to_node: Node2D) -> void:
	var from_path := from_node.get_path()
	var to_path := to_node.get_path()

	# prevent duplicates (optional)
	for c in connections:
		if c.get("from", NodePath("")) == from_path and c.get("to", NodePath("")) == to_path:
			return

	connections.append({ "from": from_path, "to": to_path })
	queue_redraw()

func remove_connection(from_node: Node2D, to_node: Node2D) -> void:
	var from_path := from_node.get_path()
	var to_path := to_node.get_path()

	for i in range(connections.size() - 1, -1, -1):
		var c := connections[i]
		if c.get("from", NodePath("")) == from_path and c.get("to", NodePath("")) == to_path:
			connections.remove_at(i)
	queue_redraw()

func _draw() -> void:
	# In the editor, only draw if enabled.
	if Engine.is_editor_hint() and not in_editor_draw:
		return

	for c in connections:
		var from_path: NodePath = c.get("from", NodePath(""))
		var to_path: NodePath = c.get("to", NodePath(""))
		if from_path == NodePath("") or to_path == NodePath(""):
			continue

		var from_node = get_node_or_null(from_path)
		var to_node = get_node_or_null(to_path)
		if from_node == null or to_node == null:
			continue
		if not (from_node is Node2D) or not (to_node is Node2D):
			continue

		var a: Vector2 = from_node.global_position
		var b: Vector2 = to_node.global_position

		# Convert global positions to this node's local space for correct draw()
		a = to_local(a)
		b = to_local(b)

		_draw_directed_edge(a, b, line_color, line_width, arrow_size)

func _draw_directed_edge(a: Vector2, b: Vector2, col: Color, w: float, arrow: float) -> void:
	# main line
	draw_line(a, b, col, w)

	# arrow head (simple triangle)
	var dir := (b - a)
	var len := dir.length()
	if len < 0.0001:
		return
	dir /= len

	var perp := Vector2(-dir.y, dir.x)

	var tip := b
	var base := tip - dir * arrow
	var left := base + perp * (arrow * 0.5)
	var right := base - perp * (arrow * 0.5)

	# filled arrowhead
	draw_polygon(PackedVector2Array([tip, left, right]), PackedColorArray([col, col, col]))
