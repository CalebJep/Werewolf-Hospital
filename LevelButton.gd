extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var room
var locked = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalData.MaxLevelEntered >= int(name):
		locked = false
		var number_string = str(int(name))
		text = "Level " + str(int(name))
		room = "res://levels/Level" + str(int(name)) + ".tscn"
	else:
		text = "Locked"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ButtonLevel_pressed():
	if !locked:
		get_tree().change_scene(room)
