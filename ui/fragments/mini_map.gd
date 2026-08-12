extends Control


func assignWorld():
	#var Camera_rid1 = Global.World.camera.get_camera_rid()			doesnt work with camera2D
	#var viewport_rid1 = Global.hud.map.get_child(0).get_viewport_rid()
	#RenderingServer.viewport_attach_camera(viewport_rid1, Camera_rid1)
	#this sucks: to display world in the map-viewport it has to be its child; anotherway would be to grab the viewport-texture and assigne it to textureRect, but then there is no input possible (f.e hover on room)
	
	Global.World.get_parent().remove_child(Global.World)
	$SubViewportContainer/SubViewport.add_child(Global.World)	


func _on_bt_zoom_in_pressed() -> void:
	Global.World.zoomOut()


func _on_bt_zoom_out_pressed() -> void:
	Global.World.zoomIn()
