extends Node

var MaxLevelEntered = 1
var save_game = "user://saved_game.save"
var quit_ui = preload("res://Objects/QuitUI.tscn")


func update_Max_Level(n):
	if n > MaxLevelEntered:
		MaxLevelEntered = n

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().get_root().get_child(get_child_count()).add_child(quit_ui.instance())

func save():
	var file = File.new()
	file.open(save_game, File.WRITE)
	file.store_var(MaxLevelEntered)
	file.close()
