extends Node


@export var horizontal_pivot: Node3D
@export var vertical_pivot: Node3D
@export var camera: Camera3D

@export_range(0.1, 0.3) var camera_sensibility: float


func horizontal_rotate(amount: float):
	horizontal_pivot.rotate_y(deg_to_rad(-amount) * camera_sensibility)
	
func vertical_rotate(amount: float):
	vertical_pivot.rotate_x(deg_to_rad(amount) * camera_sensibility)
	vertical_pivot.rotation.x = clamp(vertical_pivot.rotation.x, deg_to_rad(-60), deg_to_rad(60))
