class_name Interactor extends Area3D

@export var player_input: PlayerInput
var interacting = false
signal interact

## Initialize collisions
func _ready() -> void:
	collision_layer = 10
	collision_mask = 9
	
	if player_input == null:
		printerr(self, "no PlayerInput connected!")
		process_mode = Node.PROCESS_MODE_DISABLED
	
	player_input.interaction_down.connect(set_interacting)
	player_input.interaction_released.connect(set_interacting)

func set_interacting(state: bool) -> void:
	#print(state)
	interacting = state
	interact.emit(interacting)
