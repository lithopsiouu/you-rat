class_name State extends Node
## A [State] used by a [StateMachine]. [br]
## Used to determine when certain functions are allowed based on specified conditions.

var state_machine: StateMachine ## A reference to [StateMachine] used for switching the [State].

## Called when entering this [State].
func enter() -> void:
	pass

## Called when exiting this [State].
func exit() -> void:
	pass

## Called in the [method StateMachine._process] function.
func update(_delta: float) -> void:
	pass

## Called in the [method StateMachine._physics_process] function.
func physics_update(_delta: float) -> void:
	pass

## Checks if [param node] passed is valid and if not, disables the [State].[br]
## If [param can_skip] is [code]true[/code], this will only print an [b]error[/b].
func check_valid_node(node: Variant, can_skip: bool = false) -> void:
	if node == null:
		printerr(self, "| node not found!")
		
		if can_skip == false:
			process_mode = Node.PROCESS_MODE_DISABLED
