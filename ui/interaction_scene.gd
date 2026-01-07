extends "res://ui/default_scene.gd"


# this scene runs a dialog between PC & NPC 
# using dialog engine

@export var back_image:Texture=null		#background-image, default color if null
@export var dialogue_gdscript : GDScript = null	#dialog-script

var dialogue_engine : DialogueEngine = null
var enabled_buttons : Array[Button] = []

func _ready() -> void:
	if(back_image):
		var _image= StyleBoxTexture.new()
		_image.texture=load("res://assets/images/nav_beach_sun.png")
		$".".add_theme_stylebox_override("normal",_image)
	dialogue_engine = dialogue_gdscript.new()
	#dialogue_engine.dialogue_started.connect(__on_dialogue_started)
	dialogue_engine.dialogue_continued.connect(__on_dialogue_continued)
	dialogue_engine.dialogue_finished.connect(__on_dialogue_finished)
	dialogue_engine.dialogue_canceled.connect(__on_dialogue_canceled)
	dialogue_engine.advance()

func _input(p_input_event : InputEvent) -> void:
	if p_input_event.is_action_pressed(&"ui_accept"):
		dialogue_engine.advance()

func __displayImage(where,path):
	var _texture=Texture.new()
	if path!="":
		_texture= load(path)
	if(where==1):
		%img_char_1.texture=_texture
	else:
		%img_char_2.texture=_texture

func __on_dialogue_continued(p_dialogue_entry : DialogueEntry) -> void:
	var label : RichTextLabel = RichTextLabel.new()
	label.set_use_bbcode(true)
	label.set_fit_content(true)
	label.set_text("  > " + p_dialogue_entry.get_text())
	%log.add_child(label)

	if p_dialogue_entry.has_metadata("char1"):
		__displayImage(1,p_dialogue_entry.get_metadata("char1"))
	if p_dialogue_entry.has_metadata("char2"):
		__displayImage(2,p_dialogue_entry.get_metadata("char2"))
			
	if p_dialogue_entry.has_options():	#render buttons
		%bt_next.visible=false
		for option_id : int in range(0, p_dialogue_entry.get_option_count()):
			var option_text : String = p_dialogue_entry.get_option_text(option_id)
			var button : Button = Button.new()
			button.set_text(option_text)
			%VBoxContainer.add_child(button)
			if option_id == 0:
				button.grab_focus()
			button.pressed.connect(__advance_dialogue_with_chosen_option.bind(option_id))
			enabled_buttons.push_back(button)
		set_process_input(false)
	else:
		%bt_next.visible=true

func __advance_dialogue_with_chosen_option(p_option_id : int) -> void:
	for button : Button in enabled_buttons:
		button.set_disabled(true)
		%VBoxContainer.remove_child(button)
	enabled_buttons.clear()

	var current_entry : DialogueEntry = dialogue_engine.get_current_entry()
	current_entry.choose_option(p_option_id)
	dialogue_engine.advance()

	set_process_input(true)


func __on_dialogue_started() -> void:
	print("Dialogue Started!")

func __on_dialogue_finished() -> void:
	Global.main.removeScene(self)
	
func __on_dialogue_canceled() -> void:
	print("Dialogue Canceled! Exiting...")
	__on_dialogue_finished()

func _on_bt_1_pressed() -> void:
	dialogue_engine.advance()
