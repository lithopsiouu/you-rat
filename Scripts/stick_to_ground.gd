class_name StickToGround extends RayCast3D

## A [RayCast3D] that sets the position of [param target] to the collision
## point with [param speed].

@export var target: Node3D
@export var stick_speed: float = 10.0
@export_custom(PROPERTY_HINT_NONE, "suffix:m/s") var gravity_speed: float = 0.1
@export_category("Settings")
@export var gravity: bool = true
@export var use_offset: bool = true ## Offset target position by local position.
@export var match_hit_normal: bool = false ## Set target's orientation to match the collision normal.

func _ready() -> void:
	if target == null:
		printerr(self, "Has no target!")
		
		process_mode = Node.PROCESS_MODE_DISABLED

func _physics_process(delta: float) -> void:
	if is_colliding():
		if use_offset:
			target.global_position.y = target.global_position.lerp(get_collision_point() - position, delta * stick_speed).y
		else:
			target.global_position.y = target.global_position.lerp(get_collision_point(), delta * stick_speed).y
	else:
		target.global_position.y -= gravity_speed
