class_name RollingTube extends RigidBody3D
## A cylinder that rolls along one axis that can be entered by an NPC at either end.

var _held_character: CharacterBody3D ## Character "held" within tube.
var _character_state_machine: StateMachine ## [StateMachine] of the [param _held_character].

@export_category("Settings")

@export_group("Connections")
@export var entrance: Interactable
@export var exit: Interactable

@export_group("Rolling") # @todo add rolling functionality
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var can_roll: bool = true ## If the [RollingTube] can move.
@export var speed: float = 1.0 ## Speed of the [RollingTube].

var ends_distance: float = 0.0 ## Distance between [param entrance] and [exit] calculated at [method Node._ready].

func _ready() -> void:
	ends_distance = entrance.global_position.distance_to(exit.global_position)
	
	entrance.interaction_completed.connect(_try_enter_body.bind(entrance))
	exit.interaction_completed.connect(_try_enter_body.bind(exit))

func _try_enter_body(interactor: Interactor, area: Interactable) -> void:
	_held_character = interactor.owner
	
	var gimbal: GimbalCamera = _held_character.find_child("GimbalCamera")
	gimbal.set_new_target(self, false)
	gimbal.set_zoom_extents("in_tube")
	
	_held_character.visible = false
	
	if _try_get_state_machine():
		_character_state_machine.change_state("blocked")

func _try_get_state_machine() -> bool:
	_character_state_machine = _held_character.find_child("StateMachine")
	
	return _character_state_machine != null

# @todo finish function exit tube
func _exit_tube(area: Interactable) -> void:
	_held_character.global_position = exit.global_position
	_held_character.visible = true
	
	_character_state_machine.change_state("idle")
