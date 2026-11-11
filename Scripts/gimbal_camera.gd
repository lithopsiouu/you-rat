extends Node3D

@export var player_input: PlayerInput

@export_category("Settings")

@export var rotation_speed_y = PI / 2
@export var rotation_speed_x = PI / 2
@export var gimbal_max_x: float = -40.0
@export var gimbal_min_x: float = -15.0

func _process(delta: float) -> void:
	if abs(player_input.rotate_cam.length()) > 0:
		rotation.y += player_input.rotate_cam.x * rotation_speed_x
		$InnerGimbal.rotation.x += player_input.rotate_cam.y * rotation_speed_y
		
		$InnerGimbal.rotation_degrees.x = clampf($InnerGimbal.rotation_degrees.x, gimbal_max_x, gimbal_min_x)
