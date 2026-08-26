extends CanvasLayer

func _ready() -> void:
	visible = false
	%TabContainer.tab_changed.connect(update_list.unbind(1))

func _on_visibility_changed() -> void:
	if visible:
		Tutorials.tutorial_trigger.emit("basic_stats")
		update_list()

func update_list():
	if(%TabContainer.current_tab==0):
		update_list_status()
	else:
		update_list_skill()

func update_list_status():
	var tbl=%tbl_status
	while(tbl._total_rows>0):
		tbl.delete_row(0)
	tbl.set_headers(["Name","Range","Modifys","Modifiers"])
	var _stats=Global.pc.status.getItems()
	var _data=[]
	for _stat:Status in _stats:
		_data.push_back([_stat.ID,str(_stat.ll) +" < " + str(_stat.value)+ " < " +str(_stat.ul),
			str(_stat.modifys),str(_stat.modifier)])
	tbl.set_data(_data)

func update_list_skill():
	var tbl=%tbl_skills
	while(tbl._total_rows>0):
		tbl.delete_row(0)
	tbl.set_headers(["Name","Combat","Description","Cost to use"])
	var _items=Global.pc.skills.getItems()
	var _data=[]
	for _item:Skill in _items:
		_data.push_back([_item.getName(),_item.canUseInCombat(),_item.getDescription(),_item.getCost().asText()])
	tbl.set_data(_data)

func _on_bt_back_pressed() -> void:
	visible = false
	get_tree().paused = false
