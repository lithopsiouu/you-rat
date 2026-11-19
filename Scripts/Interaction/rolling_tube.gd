class_name RollingTube extends RigidBody3D
## A cylinder that rolls along one axis that can be entered by an NPC at either end.

var _held_character: CharacterBody3D ## Character "held" within tube.

@export var entrance: Interactable
@export var exit: Interactable

func _ready() -> void:
	entrance.interaction_completed.connect(_try_enter_body.bind(entrance))
	exit.interaction_completed.connect(_try_enter_body.bind(exit))

func _try_enter_body(interactor: Interactor, area: Interactable) -> void:
	_held_character = interactor.owner
	
	var gimbal: GimbalCamera = _held_character.find_child("GimbalCamera")
	gimbal.set_new_target(self)
	
	_held_character.visible = false
