extends CanvasLayer




# Called when the node enters the scene tree for the first time.

func _on_MenuButton_pressed():
	get_tree().change_scene("res://Menu.tscn")
	queue_free()


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_ResumeButton_pressed():
	queue_free()
