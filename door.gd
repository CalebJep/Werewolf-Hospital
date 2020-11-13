extends Node2D

var enemies
onready var label = $text_anchor/Label
onready var anim = $AnimationPlayer

func _ready():
	yield(get_tree(), "idle_frame")
	enemies = get_tree().get_nodes_in_group("werewolves")
	label.get_parent().rotation_degrees = -rotation_degrees

func update_enemies_list():
	var w = 0
	while w < enemies.size():
		if enemies[w].sedated:
			enemies.remove(w)
		else:
			w += 1

func _on_Area2D_body_entered(body):
	if body.name == "player":
		update_enemies_list()
		if enemies.size() > 0:
			label.visible = true
			label.text = str(enemies.size()) + " werewolves remaining"
		else:
			anim.play("open")


func _on_Area2D_body_exited(body):
	if body.name == "player":
		label.visible = false
