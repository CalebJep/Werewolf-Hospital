extends Control


var levelSelect = preload("res://LevelScreen.tscn")
var intro = preload("res://Intro.tscn")
var can_click = true

func _ready():
	var file = File.new()
	if file.file_exists(GlobalData.save_game):
		file.open(GlobalData.save_game, File.READ)
		GlobalData.MaxLevelEntered = file.get_var()
		file.close()

func _on_PlayButton_pressed():
	if can_click:
		add_child(intro.instance())
		can_click = false


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_LevelButton_pressed():
	if can_click:
		add_child(levelSelect.instance())
		can_click = false

