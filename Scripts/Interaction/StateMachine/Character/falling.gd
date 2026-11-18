class_name Falling extends State

## State for falling

@export var body: CharacterBody3D
@export var input: PlayerInput
@export var rotator: RotateToVelocity ## Node that rotates the [param body] to velocity.


@export_subgroup("Falling Settings")
@export var move_speed: float = 0.2 ## Speed at which the player moves in the air.

func enter() -> void:
	check_valid_node(body)
	check_valid_node(input)

func physics_update(_delta: float) -> void:
	var move_dir = input.move_dir
	
	if body.is_on_floor():
		
		if _get_is_moving(move_dir):
			state_machine.change_state("Walking")
			
		else:
			state_machine.change_state("Idle")
	else:
		move(move_dir)
		
		if _get_is_moving(move_dir):
			rotator.rotate(_delta)
	


func _get_is_moving(dir: Vector2) -> bool:
	return abs(dir.length()) > 0.0

## Sets [RigidBody3D.velocity] to [param dir] times [param speed] plus [code]gravity[/code].
func move(dir: Vector2) -> void:
	var move_vel: Vector3 = Vector3(dir.x, 0.0, dir.y) * move_speed
	var force: Vector3 = move_vel + body.get_gravity()
	
	body.velocity = force
	
	body.move_and_slide()
