class_name GimbalCamera extends Node3D

@onready var gim: Node3D = %InnerGimbal ## Gimbal rotating on the [code]X[/code] axis.
@onready var cam: Camera3D = %Camera3D ## Camera of the [GimbalCamera].

@export var target: Node3D

var player_input: PlayerInput

@export_category("Settings")
@export var transform_to_target: bool = true
@export var zoom_strength: float = 0.1

@export_group("Use Start Orientation")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var use_start_orientation: bool = false
@export_custom(PROPERTY_HINT_NONE, "suffix:°") var start_x_rotation: float = -30.0
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var start_zoom: float = 2.8

@export_subgroup("Speed")
@export var speed_y = PI / 2 ## Speed of rotation on the [code]Y[/code] axis, multiplied by [code]delta[/code].
@export var speed_x = PI / 2 ## Speed of rotation on the [code]X[/code] axis, multiplied by [code]delta[/code].

@export_group("Limits")

@export_subgroup("Rotation")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var use_rotation_limits: bool = true
@export var gimbal_min_x: float = -15.0 ## Minimum x (lowest tilt) rotation. 
@export var gimbal_max_x: float = -40.0 ## Maximum x (lowest tilt) rotation. 

@export_subgroup("Zoom")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var use_zoom_limits: bool = true
@export var zoom_min: float = 2.0
@export var zoom_max: float = 3.2

# @todo eventually use zoom extents dict
var zoom_extents: Dictionary[String, Vector2] = { ## Contains [param zoom_min] and [param zoom_max] values in a [Vector2].[codeblock]"extent_name": Vector2(min, max)[/codeblock]Used with [method GimbalCamera.set_zoom_extents].
	"default": Vector2(2.6, 3.1),
	"in_tube": Vector2(3.1, 3.6)
}


func _ready() -> void:
	player_input = target.find_child("Components").find_child("PlayerInput")


func _process(delta: float) -> void:
	_move_to_target()
	
	if abs(player_input.rotate_cam.length()) > 0:
		_gim_rotation(delta)
	
	if Input.is_action_just_pressed("zoom_cam_in"):
		mod_zoom(zoom_strength)
	elif Input.is_action_just_pressed("zoom_cam_out"):
		mod_zoom(-zoom_strength)


## Rotate [member GimbalCamera.gim] and limit x rotation if [param use_rotation_limits] is [code]true[/code].
func _gim_rotation(_delta: float) -> void:
	rotation.y = move_toward(rotation.y, rotation.y + player_input.rotate_cam.x, _delta * speed_x)
	gim.rotation.x = move_toward(gim.rotation.x, gim.rotation.x + player_input.rotate_cam.y, _delta * speed_y)
	
	if use_rotation_limits:
		gim.rotation_degrees.x = clampf(gim.rotation_degrees.x, gimbal_max_x, gimbal_min_x)


## Sets [param target] to [param new_target].
func set_new_target(new_target: Node3D, keep_global_transform: bool = true) -> void:
	target = new_target
	reparent(target, keep_global_transform)


## Sets [member Node3D.transform] to the [b]position[/b] of [param target].
func _move_to_target() -> void:
	if transform_to_target:
		position = target.position


## Change [param zoom_min] and [param zoom_max] to value in [member GimbalCamera.zoom_extents] using [param extent_name]
func set_zoom_extents(extent_name: String) -> void:
	extent_name = extent_name.to_lower()
	
	if zoom_extents.has(extent_name):
		zoom_min = zoom_extents[extent_name].x
		zoom_max = zoom_extents[extent_name].y
		set_zoom(0.5)
	else:
		printerr("Extent '", extent_name, "' does not exist!")


## [b]Set[/b] [member Node3D.transform.z] (distance) of [member GimbalCamera.cam] with a [b]value[/b] between [code]0[/code] and [code]1[/code] (min and max zoom).
func set_zoom(value: float) -> void:
	value = clampf(value, 0, 1)
	
	cam.position.z = lerp(zoom_min, zoom_max, value)


## [b]Increase[/b] or [b]decrease[/b] [member Node3D.transform.z] (distance) of [param cam] clamped between [param zoom_min] and [param zoom_max].
func mod_zoom(value: float) -> void:
	cam.position.z += value
	
	if use_zoom_limits:
		cam.position.z = clamp(cam.position.z, zoom_min, zoom_max)
