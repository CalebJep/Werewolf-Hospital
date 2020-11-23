extends Area2D


var next_room
var victory = preload("res://Objects/VictoryUI.tscn")

func _ready():
	next_room = int(get_tree().current_scene.name) + 1
	

func _on_stairs_area_entered(area):
	var path_to_file = "res://levels/Level" + str(next_room) + ".tscn"
	if ResourceLoader.exists(path_to_file):
		GlobalData.update_Max_Level(next_room)
		GlobalData.save()
		get_tree().change_scene(path_to_file)
	else:
		get_parent().add_child(victory.instance())
