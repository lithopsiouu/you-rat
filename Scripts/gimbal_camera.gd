extends Node3D

@export var target: CharacterBody3D
var player_input: PlayerInput

@export_category("Settings")
@export var transform_to_target: bool = true
@export_subgroup("Speed")
@export var rotation_speed_y = PI / 2
@export var rotation_speed_x = PI / 2
@export_subgroup("Limits")
@export var gimbal_max_x: float = -40.0
@export var gimbal_min_x: float = -15.0


func _ready() -> void:
	player_input = target.find_child("Components").find_child("PlayerInput")


func _process(delta: float) -> void:
	_move_to_target()
	
	if abs(player_input.rotate_cam.length()) > 0:
		rotation.y += player_input.rotate_cam.x * rotation_speed_x
		$InnerGimbal.rotation.x += player_input.rotate_cam.y * rotation_speed_y
		
		$InnerGimbal.rotation_degrees.x = clampf($InnerGimbal.rotation_degrees.x, gimbal_max_x, gimbal_min_x)


func _move_to_target() -> void:
	if transform_to_target:
		position = target.position
