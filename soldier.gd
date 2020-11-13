extends KinematicBody2D

export(int) var SPEED
export(int) var VIEW_ANGLE
export(int) var VIEW_DIST
export(float) var ACCEL
export(NodePath) var PatrolPathContainer

onready var anim = $AnimationPlayer
onready var ray = $RayCast2D
onready var line = $Line2D

var patrol_path = []
var current_patrol_point = 0
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemies")
	if PatrolPathContainer:
		var temp_array = get_node(PatrolPathContainer).get_children()
		for path_point_node in temp_array:
			patrol_path.append(path_point_node.global_position)

func _physics_process(delta):
	if player:
		var vector_to_player = player.global_position - position
		ray.cast_to = vector_to_player
		line.points[1] = vector_to_player
		if !anim.is_playing():
			var move_vector = patrol_path[current_patrol_point] - global_position
			if move_vector.length_squared() <= 10:
				current_patrol_point = (current_patrol_point + 1) % patrol_path.size()
			rotation = lerp_angle(rotation, move_and_slide(move_vector.normalized() * SPEED).angle(), ACCEL)
			ray.rotation = - rotation
			if ray.is_colliding() and ray.get_collider().name == "player" and ray.cast_to.length() <= VIEW_DIST and acos(vector_to_player.normalized().dot(transform.x)) <= deg2rad(VIEW_ANGLE / 2):
				anim.play("detect")
				
		else:
			rotation = ray.cast_to.angle()
			ray.rotation = -rotation
		

func set_player(thing):
	player = thing

func shoot():
	if ray.is_colliding():
		var hit = ray.get_collider()
		if hit.has_method("die"):
			hit.die()


func _on_Area2D_body_entered(body):
	if body.name == "player":
		anim.play("detect")
