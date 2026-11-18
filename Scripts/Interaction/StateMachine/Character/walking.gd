class_name Walking extends State
## State for walking

@export var body: CharacterBody3D ## Node to control.
@export var input: PlayerInput ## Node that sends player input.
@export var rotator: RotateToVelocity ## Node that rotates the [param body] to velocity.

@export_subgroup("Walking Settings")
@export var move_speed: float = 0.8 ## Speed at which the player moves.

func enter() -> void:
	check_valid_node(body)
	check_valid_node(input)

func physics_update(_delta: float) -> void:
	var move_dir = input.move_dir
	rotator.rotate(_delta)
	
	if abs(move_dir.length()) == 0.0:
		state_machine.change_state("Idle")
		
	elif body.is_on_floor():
		move(move_dir)
		
	else:
		state_machine.change_state("Falling")
	

## Sets [RigidBody3D.velocity] to [param dir] times [param speed] plus [code]gravity[/code].
func move(dir: Vector2) -> void:
	var move_vel: Vector3 = Vector3(dir.x, 0.0, dir.y) * move_speed
	var force: Vector3 = move_vel + body.get_gravity()
	
	body.velocity = force
	
	body.move_and_slide()
