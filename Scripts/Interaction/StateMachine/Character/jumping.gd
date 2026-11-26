class_name Jumping extends State

## State for jumping.

@export_subgroup("Connections")
@export var body: CharacterBody3D
@export var input: PlayerInput
@export var rotator: RotateToVelocity ## Node that rotates the [param body] to velocity.

@export_subgroup("Jumping Settings")
@export var jump_strength: float = 3.0 ## Strength with which the body jumps.
@export var move_influence: float = 1.1 ## Speed at which the player moves in the air.
@export var jump_decay: float = 11 ## Speed at which the jump decays at.

var _ignore_floor_time: float = 0.1 ## Time to ignore [method CharacterBody3D.is_on_floor] for.
var _floor_ignored: bool = true

func _ready() -> void:
	check_valid_node(body)
	check_valid_node(input)
	check_valid_node(rotator)

func enter() -> void:
	_floor_ignored = true
	body.velocity.y = jump_strength
	#get_tree().create_timer(_ignore_floor_time).timeout.connect(_unignore_floor)

func physics_update(_delta: float) -> void:
	
	if body.is_on_floor() and _floor_ignored == false:
		
		if input.move_dir.length() > 0.0:
			state_machine.change_state("Walking")
			
		else:
			state_machine.change_state("Idle")
			
	elif body.velocity.y < 0.0:
		state_machine.change_state("Falling")
		
	else:
		move(input.move_dir, _delta)


## Sets [RigidBody3D.velocity] to [param dir] times [param speed] plus [code]gravity[/code].
func move(dir: Vector2, _delta: float) -> void:
	var move_vel: Vector3 = Vector3(dir.x, 0.0, dir.y) * move_influence
	var force: Vector3 = move_vel + body.get_gravity()
	
	body.velocity = Vector3(force.x, move_toward(body.velocity.y, force.y, _delta * jump_decay), force.z)
	
	body.move_and_slide()
	print(body.velocity.y)

func _unignore_floor() -> void:
	_floor_ignored = false
