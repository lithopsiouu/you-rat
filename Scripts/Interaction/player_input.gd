class_name PlayerInput extends Node

var move_dir: Vector2 = Vector2.ZERO
var look_dir: Vector2 = Vector2.ZERO
var rotate_cam: Vector2 = Vector2.ZERO
signal interaction_down
signal interaction_released
@export_category("Settings")
@export var move_relative_to_camera: bool = true
@export var invert_cam_x: bool = true
@export var invert_cam_y: bool = false
var _cam: Camera3D

func _ready() -> void:
	_cam = get_viewport().get_camera_3d()


func _input(event: InputEvent) -> void:
	move_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	#print(move_dir)
	
	if move_relative_to_camera:
		move_dir = _rotate_vector(move_dir)
	
	rotate_cam = Input.get_vector("rotate_cam_left", "rotate_cam_right", "rotate_cam_up", "rotate_cam_down")
	if invert_cam_x:
		rotate_cam.x = -rotate_cam.x
	if invert_cam_y:
		rotate_cam.y = -rotate_cam.y
	
	if Input.is_action_just_pressed("interact"):
		interaction_down.emit(true)
	elif Input.is_action_just_released("interact"):
		interaction_released.emit(false)


func _rotate_vector(vector: Vector2) -> Vector2:
	var rotated_vec: Vector2 = Vector2.ZERO
	if _cam:
		rotated_vec = vector.rotated(-_cam.global_rotation.y)
	return rotated_vec
