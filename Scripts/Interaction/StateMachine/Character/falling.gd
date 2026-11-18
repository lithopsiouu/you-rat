class_name Falling extends State

## State for falling

@export_subgroup("Connections")
@export var body: CharacterBody3D
@export var input: PlayerInput
@export var rotator: RotateToVelocity ## Node that rotates the [param body] to velocity.
@export var coyote: CoyoteTime ## Node that tracks coyote time after leaving the ground.

@export_subgroup("Falling Settings")
@export var move_influence: float = 0.8 ## Speed at which the player moves in the air.
@export var gravity_power: float = 12 ## Multiplies speed of when gravity takes effect

var _can_jump: bool = false ## Value that determines ability to jump in the air.
var _jump_pressed: bool = false ## Value changing to match [signal PlayerInput.jumping].

func enter() -> void:
	check_valid_node(body)
	check_valid_node(input)
	check_valid_node(rotator)
	check_valid_node(coyote, true)
	
	input.jumping.connect(_set_jump_pressed)
	if coyote != null:
		coyote.coyote_changed.connect(_set_can_jump)

func physics_update(_delta: float) -> void:
	var move_dir = input.move_dir
	
	if body.is_on_floor():
		
		if _get_is_moving(move_dir):
			state_machine.change_state("Walking")
			
		else:
			state_machine.change_state("Idle")
	elif _jump_pressed and _can_jump:
		state_machine.change_state("Jumping")
	else:
		move(move_dir, _delta)
		
		if _get_is_moving(move_dir):
			rotator.rotate(_delta)
	


func _get_is_moving(dir: Vector2) -> bool:
	return abs(dir.length()) > 0.0


## Sets [member RigidBody3D.velocity] to [param dir] times [param speed] plus [code]gravity[/code].
func move(dir: Vector2, _delta: float) -> void:
	var move_vel: Vector3 = Vector3(dir.x, 0.0, dir.y) * move_influence
	var force: Vector3 = move_vel + body.get_gravity()
	
	body.velocity = _move_vector(body.velocity, force, _delta)
	
	body.move_and_slide()

## Called when [param coyote] emits [signal CoyoteTime.coyote_changed].
func _set_can_jump(value: bool) -> void:
	_can_jump = value

## Called when [param input] emits [signal PlayerInput.jumping].
func _set_jump_pressed(value: bool) -> void:
	_jump_pressed = value

## Returns [param current] moved by [param speed] to [param target].
func _move_vector(current: Vector3, target: Vector3, speed: float) -> Vector3:
	var moved_vel: Vector3 = Vector3.ZERO
	
	moved_vel.x = move_toward(current.x, target.x, speed * gravity_power)
	moved_vel.y = move_toward(current.y, target.y, speed * gravity_power)
	moved_vel.z = move_toward(current.z, target.z, speed * gravity_power)
	
	return moved_vel
