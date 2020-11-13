extends Node

var MaxLevelEntered = 1

func update_Max_Level(n):
	if n > MaxLevelEntered:
		MaxLevelEntered = n

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
