extends Node


@export var state_controller: Node

@export var player_body: CharacterBody3D
@export var player_collider: CollisionShape3D
@export var camera_horizontal_pivot: Node3D


var vertical_velocity: float = 0
var input_vector: Vector2 = Vector2.ZERO
var is_walking_pressed: bool = false

const RUNNING_SPEED: float = 6
const WALKING_SPEED: float = 2
const ROTATION_MATRIX = [[ 45,    0,  315 ],
						 [ 90,    0,  270 ],
						 [ 135, 180, 225 ]]


func _process(delta: float):
	update_vertical_velocity(delta)
	adjust_player_rotation()
	move_player()
	update_state()

func update_vertical_velocity(delta: float):
	if !player_body.is_on_floor():
		vertical_velocity -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta
	else:
		vertical_velocity = max(vertical_velocity, 0)

func update_input_vector(value: Vector2):
	input_vector = value

func update_walking(value: bool):
	is_walking_pressed = value

func adjust_player_rotation():
	if input_vector.length() > 0:
		var current_rotation = rad_to_deg(player_collider.rotation.y)
		
		var target_rotation_value = rad_to_deg(camera_horizontal_pivot.rotation.y) + get_input_direction_angle()
		
		var clockwise_rotation_value = get_angle_distance_clockwise(current_rotation, target_rotation_value)
		var counter_clockwise_rotation_value = get_angle_distance_counter_clockwise(current_rotation, target_rotation_value)
		
		var rotation_sign = 1 if counter_clockwise_rotation_value <= clockwise_rotation_value else -1
		var rotation_amount = min(clockwise_rotation_value, counter_clockwise_rotation_value)
		
		player_collider.rotate_y(lerpf(0, deg_to_rad(rotation_amount) * rotation_sign, 0.2))

func get_input_direction_angle():
	return ROTATION_MATRIX[-input_vector.y + 1][input_vector.x + 1]

func get_angle_distance_clockwise(from: float, to: float):
	return from - to if to <= from else from + 360 - to
	
func get_angle_distance_counter_clockwise(from: float, to: float):
	return to - from if to >= from else to + 360 - from

func move_player():
	var velocity_vertical_vector = Vector3(0, vertical_velocity, 0)
	var velocity_horizontal_vector = Vector3.ZERO
	
	if input_vector.length() > 0:
		var speed = WALKING_SPEED if is_walking_pressed else RUNNING_SPEED
		velocity_horizontal_vector = get_movement_direction() * speed
		
	player_body.velocity = velocity_vertical_vector + velocity_horizontal_vector
	player_body.move_and_slide()

func get_movement_direction():
	return camera_horizontal_pivot.basis.z.rotated(Vector3.UP, deg_to_rad(get_input_direction_angle()))

func update_state():
	if vertical_velocity > 0:
		return
	
	if vertical_velocity < 0:
		return
	
	if input_vector.length() > 0:
		if is_walking_pressed:
			state_controller.go_walking()
			return
		state_controller.go_running()
		return
	
	state_controller.go_iddle()
