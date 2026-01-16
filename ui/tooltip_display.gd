extends Control


		
@export var showBelow = false
@onready var _title:Label=$Panel/VBoxContainer/lb_header
@onready var _body:RichTextLabel=$Panel/VBoxContainer/lb_body
@onready var _tween:AnimationPlayer=$Tween

var is_active:bool = false:
	set(value):
		is_active=value
		if value:
		#	_tween..remove_all()
		#	_tween.interpolate_property(self, "modulate", Color(0.0, 0.0, 0.0, -6.0), Color.WHITE, 0.6)
		#	_tween.start()
			modulate = Color.WHITE
		else:
		#	_tween.remove_all()
		#	_tween.interpolate_property(self, "modulate", modulate, Color.TRANSPARENT, 0.2)
		#	_tween.start()
			modulate = Color.TRANSPARENT
	get:
		return is_active

var is_wide:bool=false:
	set(value):
		if(value):
			custom_minimum_size.x = 500
		else:
			custom_minimum_size.x = 250

func _ready() -> void:
	modulate = Color.TRANSPARENT
	is_active=false

func _process(_delta: float) -> void:
	var _pos:Vector2
	var _viewsize:Vector2=get_viewport_rect().size
	if(showBelow):
		_pos = get_global_mouse_position()-Vector2(size.x/2.0, 0) + pivot_offset
	else:
		_pos = get_global_mouse_position() - Vector2(size.x/2.0, size.y) - pivot_offset
		_pos.x = max(10, _pos.x)
		_pos.x = min(_viewsize.x - 10 - size.x, _pos.x)
		_pos.y = max(10, _pos.y)
		_pos.y = min(_viewsize.y - 10 - size.y, _pos.y)
	global_position=_pos

func set_text(title: String, body: String):
	_title.text = title.capitalize()
	_body.text=(body)
	size.y = 0	#the label would not shrink back otherwise
	size.x = 0
