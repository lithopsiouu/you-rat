class_name Movement extends Component

## Allows movement of the [param target]

var move_dir: Vector3
var move_vel: Vector3 = Vector3.ZERO
@export var input: PlayerInput
@export var speed: float = 3.0
@export var mesh: MeshInstance3D

func _ready() -> void:
	_is_target_null(target)
	_is_target_null(input)


func _process(delta: float) -> void:
	set_move_dir(input.move_dir)
	#mesh.look_at(target.position + Vector3(move_dir.z, 0, -move_dir.x))
	
	if abs(move_dir.length()) > 0.0:
	
		mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(-move_dir.z, move_dir.x), delta * 8)
		
		move()


func set_move_dir(new_dir) -> void:
	if new_dir is Vector3:
		move_dir = new_dir
	elif new_dir is Vector2:
		move_dir.x = new_dir.x
		move_dir.z = new_dir.y


func update_move_vel() -> void:
	move_vel = move_dir * speed


func move() -> void:
	update_move_vel()
	target.global_position += move_vel
	mesh.rotation.z = 0
	mesh.rotation.x = 0
	
