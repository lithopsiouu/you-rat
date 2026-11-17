class_name RigidBodyMovement extends Component

## Allows movement of the [param target] of type [CharacterBody3D]

var _pid := Pid3D.new(1.0, 0.08, 1.0)
var move_dir: Vector3
var move_vel: Vector3 = Vector3.ZERO
var rb: CharacterBody3D = null
@export var input: PlayerInput
@export var speed: float = 0.018
@export var mesh: MeshInstance3D

var current_speed
var target_speed
var acceleration_time

func _ready() -> void:
	_is_target_null(target)
	_is_target_null(input)
	
	if target is CharacterBody3D: 
		rb = target
	else:
		printerr(self, "No RigidBody3D to use!")
		process_mode = Node.PROCESS_MODE_DISABLED


func _physics_process(delta: float) -> void:
	move_dir_to_vec3(input.move_dir)
	
	update_move_vel()
	move(move_vel)
	
	if abs(move_dir.length()) > 0.0:
	
		mesh.rotation.y = get_rotation_from_dir(delta)
		pass
	
	else:
		pass
		#rb.apply_central_impulse(Vector3(rb.linear_velocity.x, 0, rb.linear_velocity.z) * -1)

## Change [param new_dir] to [param move_dir] ([Vector2] to [Vector3]) on the [code]x[/code] and [code]z[/code] axes.
func move_dir_to_vec3(new_dir) -> void:
	if new_dir is Vector3:
		move_dir = new_dir
	elif new_dir is Vector2:
		move_dir.x = new_dir.x
		move_dir.z = new_dir.y

## Return a rotation in radians.
func get_rotation_from_dir(_delta: float) -> float:
	return lerp_angle(mesh.rotation.y, atan2(-move_dir.z, move_dir.x), _delta * 8)

## Update [param move_vel] by multiplying [param move_dir] by [param speed].
func update_move_vel() -> void:
	move_vel = move_dir * speed

## Sets the [member CharacterBody3D.velocity] to [param _vel] and triggers [method CharacterBody3D.move_and_slide].
func move(_vel: Vector3) -> void:
	rb.velocity = _vel + rb.get_gravity()
	rb.move_and_slide()
	#mesh.rotation.z = 0
	#mesh.rotation.x = 0
