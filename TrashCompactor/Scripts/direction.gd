extends Button

func _pressed():
	var node = get_tree().get_root().get_node("UI")
	$"../AudioStreamPlayer".play()
	match (name):
		"Up":
			node.moveUp()
		"Down":
			node.moveDown()
		"Left":
			node.moveLeft()
		"Right":
			node.moveRight()
