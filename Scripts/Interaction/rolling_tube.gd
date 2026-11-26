class_name RollingTube extends RigidBody3D
## A cylinder that rolls along one axis that can be entered by an NPC at either end.

var _held_character: CharacterBody3D ## Character "held" within tube.
var _character_state_machine: StateMachine ## [StateMachine] of the [param _held_character].
var _gim_cam: GimbalCamera ## [GimbalCamera] of the [b]player[/b].
var _char_inpt: PlayerInput ## Input of the player.

signal character_entered ## Emitted when a [CharacterBody3D] has entered the [RollingTube].
signal character_exited ## Emitted when a [CharacterBody3D] has exited the [RollingTube].

@export_category("Settings")

@export_group("Connections")
@export var entrance: Interactable
@export var exit: Interactable
@export var dolly: Node3D ## Node3D that holds the [param _gim_cam]. Used to move the [b]camera[/b] along the [RollingTube].

@export_group("Rolling") # @todo add rolling functionality
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var can_roll: bool = true ## If the [RollingTube] can move.
@export var speed: float = 1.0 ## Speed of the [RollingTube].

@export_group("Exiting")
@export var exit_time: float = 0.2 ## Time it takes to "move" from the center to either end.
@export_range(0.0, 1.0, 0.05) var exit_direction_similarity: float = 0.1 ## Amount of deviance from either exit direction to begin exiting.
var exit_timer: Timer ## Tracks time of exit.

var ends_distance: float = 0.0 ## Distance between [param entrance] and [exit] calculated at [method Node._ready].

func _ready() -> void:
	ends_distance = entrance.global_position.distance_to(exit.global_position)
	
	entrance.interaction_completed.connect(_try_enter_body.bind(entrance))
	exit.interaction_completed.connect(_try_enter_body.bind(exit))

func _try_enter_body(interactor: Interactor, area: Interactable) -> void:
	_held_character = interactor.owner
	_gim_cam = _held_character.find_child("GimbalCamera")
	
	if _held_character != null:
		_char_inpt = _held_character.find_child("PlayerInput")
	
	if _gim_cam != null: _retarget_cam(dolly, true)
	
	_held_character.visible = false
	
	character_entered.emit(_held_character)
	
	if _try_get_state_machine():
		_character_state_machine.change_state("blocked")


func _input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("return"):
		_exit_tube(exit)


func _try_get_state_machine() -> bool:
	_character_state_machine = _held_character.find_child("StateMachine")
	
	return _character_state_machine != null


## Sets the [b]parent[/b] and [b]zoom extents[/b] of the [param _gim_cam].
func _retarget_cam(target: Node3D, tube_cam_extents: bool) -> void:
	
	_gim_cam.set_new_target(target, false)
	
	if tube_cam_extents:
		_gim_cam.set_zoom_extents("in_tube")
	else:
		_gim_cam.set_zoom_extents("default")


func _move_dolly() -> void:
	pass # @todo make dolly move, fix cam offset bug

func _visualize_exit() -> void:
	pass # @hack return here, use dot() to start approaching exit

# @todo finish function exit tube
func _exit_tube(area: Interactable) -> void:
	character_exited.emit(_held_character)
	_held_character.global_position = exit.global_position
	_held_character.visible = true
	
	_retarget_cam(_held_character, false)
	_character_state_machine.change_state("idle")
	
	_held_character = null
	_character_state_machine = null
