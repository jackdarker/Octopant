extends CanvasLayer

func _ready() -> void:
	visible = false

func _on_visibility_changed() -> void:
	if visible:
		Tutorials.tutorial_trigger.emit("basic_stats")
		update_list()

func update_list():
	while(%tbl._total_rows>0):
		%tbl.delete_row(0)
	%tbl.set_headers(["Name","Range","Modifys","Modifiers"])
	var _stats=Global.pc.status.getItems()
	var _data=[]
	for _stat:Status in _stats:
		_data.push_back([_stat.ID,str(_stat.ll) +" < " + str(_stat.value)+ " < " +str(_stat.ul),
			str(_stat.modifys),str(_stat.modifier)])
	%tbl.set_data(_data)

func _on_bt_back_pressed() -> void:
	visible = false
	get_tree().paused = false
