extends CanvasLayer


export(Array, String) var death_jokes
onready var label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/PanelContainer/Label


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	label.text = "'" + death_jokes[randi() % death_jokes.size()] + "'"


func _input(event):
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()


func _on_RestartButton_pressed():
	get_tree().reload_current_scene()# Replace with function body.


func _on_MenuButton_pressed():
	get_tree().change_scene("res://Menu.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
