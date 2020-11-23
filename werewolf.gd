extends KinematicBody2D


export(int) var SPEED
export(int) var ATTACK_SPEED
export(float) var ACCEL
export(float) var VIEW_ANGLE
export(int) var VIEW_LENGTH = 1000


onready var timer = $Timer
onready var ray = $RayCast2D
onready var attack_box = $Area2D
onready var normal_sprite = $Sprite
onready var sedated_sprite = $Sprite_sedated
onready var collision = $CollisionShape2D
onready var anim_player = $AnimationPlayer

var motion = Vector2()
var target_angle = 0
var player
var sees_player = false
var sedated = false

func _ready():
	add_to_group("enemies")
	add_to_group("werewolves")

func _physics_process(delta):
	if !sedated:
		check_for_player()
		rotation = lerp_angle(rotation, target_angle, ACCEL)
		if !sees_player:
			motion = move_and_slide(transform.x * SPEED)
		elif !anim_player.is_playing():
			motion = move_and_slide(transform.x * ATTACK_SPEED)
		if motion.length_squared() <= 0.1 * SPEED * SPEED:
			target_angle = target_angle + PI
	

func check_for_player():
	if player:
		var view = 360
		var vector_to_player = player.global_position - global_position
		ray.cast_to = vector_to_player
		ray.rotation_degrees = -rotation_degrees
		if !sees_player:
			view = VIEW_ANGLE
		if acos(vector_to_player.normalized().dot(transform.x)) <= deg2rad(view / 2):
			
			if ray.is_colliding() and vector_to_player.length() <= VIEW_LENGTH:
				var ray_hit = ray.get_collider()
				if ray_hit.name == "player":
					set_sight(true)
					target_angle = vector_to_player.angle()
				else:
					set_sight(false)
			else:
				set_sight(false)
		else:
			set_sight(false)
	

func set_sight(is_seeing):
	if sees_player != is_seeing:
		if is_seeing:
			anim_player.play("alert")
		else:
			anim_player.play("confused")
		sees_player = is_seeing

func _on_Timer_timeout():
	if !sedated:
		if !sees_player:
			new_direction()

func new_direction():

	randomize()
	target_angle = deg2rad(randi() % 360)
	
func set_player(thing):
	player = thing

func sedate():
	if !sedated:
		sedated = true
		z_index = -1
		collision.disabled = true
		attack_box.monitoring = false
		normal_sprite.visible = false
		sedated_sprite.visible = true
	

func _on_Area2D_body_entered(body):
	if body.has_method("die"):
		body.die()

