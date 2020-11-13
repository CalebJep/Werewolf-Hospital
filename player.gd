extends KinematicBody2D


export(int) var SPEED
export(float) var ACCEL

onready var hint_button = $button_pivot
onready var sedate_sound = $sedate_sound
onready var walk_sound = $walk_sound
onready var normal_sprite = $Sprite
onready var dead_sprite = $DeadSprite
onready var area = $Area2D
onready var light = $Light2D
onready var collision = $CollisionShape2D

var motion = Vector2()
var target_object = null
var dead = false
var death_ui = preload("res://Objects/death_ui.tscn")

func _ready():
	light.visible = true
	yield(get_tree(), "idle_frame")
	get_tree().call_group("enemies", "set_player", self)

func _physics_process(delta):
	if !dead:
		move()
		if target_object:
			hint_button.rotation = -rotation
			if Input.is_action_just_pressed("sedate"):
				print("Sedating " + target_object.name)
				if target_object.has_method("sedate"):
					target_object.sedate()
					sedate_sound.play()
	
	
func move():
	var LEFT = int(Input.is_action_pressed("ui_left"))
	var RIGHT = int(Input.is_action_pressed("ui_right"))
	var UP = int(Input.is_action_pressed("ui_up"))
	var DOWN = int(Input.is_action_pressed("ui_down"))
	var target_motion = Vector2(RIGHT - LEFT, DOWN - UP).normalized()
	motion = lerp(motion, target_motion, ACCEL)
	var actual_motion = move_and_slide(motion * SPEED)
	if target_motion != Vector2.ZERO and actual_motion.length_squared() >= .01 * SPEED:
		rotation = motion.angle()
		if !walk_sound.playing:
			walk_sound.play()

func die():
	if !dead:
		dead = true
		normal_sprite.visible = false
		dead_sprite.visible = true
		area.monitoring = false
		collision.disabled = true
		yield(get_tree().create_timer(1), "timeout")
		get_parent().add_child(death_ui.instance())
	#get_tree().reload_current_scene()


func _on_Area2D_body_entered(body):
	if body.has_method("sedate") and target_object == null:
		target_object = body
		hint_button.visible = true
		print(target_object.name)


func _on_Area2D_body_exited(body):
	if body == target_object:
		target_object = null
		hint_button.visible = false
