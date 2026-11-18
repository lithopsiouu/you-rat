class_name Idle extends State

## Idle state.

@export var body: CharacterBody3D
@export var input: PlayerInput

func enter() -> void:
	check_valid_node(body)
	check_valid_node(input)


func physics_update(_delta: float) -> void:
	if abs(input.move_dir.length()) > 0.0:
		state_machine.change_state("Walking")
