class_name RigidBodyMovement extends Component

## Allows movement of the [param target] of type [RigidBody3D]

var _pid := Pid3D.new(1.0, 0.08, 1.0)
var move_dir: Vector3
var move_vel: Vector3 = Vector3.ZERO
var rb: RigidBody3D = null
@export var input: PlayerInput
@export var speed: float = 0.018
@export var mesh: MeshInstance3D

func _ready() -> void:
	_is_target_null(target)
	_is_target_null(input)
	
	if target is RigidBody3D: 
		rb = target
	else:
		printerr(self, "No RigidBody3D to use!")
		process_mode = Node.PROCESS_MODE_DISABLED


func _physics_process(delta: float) -> void:
	set_move_dir(input.move_dir)
	#mesh.look_at(target.position + Vector3(move_dir.z, 0, -move_dir.x))
	
	update_move_vel()
	var velocity_error = move_vel - rb.linear_velocity
	var impulse = _pid.update(velocity_error, delta) * .1
	move(impulse)
	
	if abs(move_dir.length()) > 0.0:
	
		#mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(-move_dir.z, move_dir.x), delta * 8)
		pass
	
	else:
		#pass
		rb.apply_central_impulse(Vector3(rb.linear_velocity.x, 0, rb.linear_velocity.z) * -1)


func set_move_dir(new_dir) -> void:
	if new_dir is Vector3:
		move_dir = new_dir
	elif new_dir is Vector2:
		move_dir.x = new_dir.x
		move_dir.z = new_dir.y


func update_move_vel() -> void:
	move_vel = move_dir * speed


func move(_vel: Vector3) -> void:
	rb.apply_central_force(_vel)
	mesh.rotation.z = 0
	mesh.rotation.x = 0
