extends Character


func _init():
	super()
	self.ID="Lutes"

func getBustImage()->Texture2D:
	return load("res://assets/images/chars/lutes.png")
