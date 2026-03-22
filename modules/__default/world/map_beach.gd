extends Map


func _init() -> void:
	var id="beach1"
	actualRoom=id
	rooms[id]=Map.Room.new(id,id,Vector3(0,0,0))
	id="beach2"
	rooms[id]=Map.Room.new(id,id,Vector3(0,1,0))
	id="beach3"
	rooms[id]=Map.Room.new(id,id,Vector3(0,2,0))
	
	id="1_2"
	doors[id]=Map.Door.new(id,"beach1","beach2")
	id="2_3"
	doors[id]=Map.Door.new(id,"beach2","beach3")
	id="3_1"
	doors[id]=Map.Door.new(id,"beach3","beach1")
