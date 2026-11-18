class_name RotateToVelocity extends Node

@export var target: CharacterBody3D

@export_subgroup("Settings")
@export var rotate_speed: float = 7.0

func _ready() -> void:
	if target == null:
		printerr(self, "| No target found to rotate!")
		process_mode = Node.PROCESS_MODE_DISABLED


#func _process(delta: float) -> void:
	#target.rotation.y = _rot_from_vel(delta)

func rotate(_delta: float) -> void:
	target.rotation.y = _rot_from_vel(_delta)

## Return a rotation in radians.
func _rot_from_vel(_delta: float) -> float:
	return lerp_angle(target.rotation.y, atan2(-target.velocity.z, target.velocity.x), _delta * rotate_speed)
