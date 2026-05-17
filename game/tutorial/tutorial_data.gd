class_name TutorialData extends Resource

# 
@export var ID: String = ""
@export var title: String = ""
@export_multiline var text: String = ""
@export var icon_path: String = ""
@export var anchor: String = "center"
@export var show_once: bool = true
@export var auto_close: bool = false
@export var auto_close_delay: float = 3.0
@export var close_condition: Dictionary = {} # e.g., {"node": "/root/Scene", "signal": "choice_made"}
