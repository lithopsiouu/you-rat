extends CanvasLayer

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var cam: Camera3D = get_viewport().get_camera_3d()
var interactor: Interactor
var interactable: Interactable
var can_interact: bool = false

func _ready() -> void:
	await player.find_child("Interactor")
	interactor = player.find_child("Interactor")
	
	interactor.area_entered.connect(_prep_prompt)
	interactor.area_exited.connect(_hide_prompt)

func _process(delta: float) -> void:
	if can_interact:
		$Panel.position = cam.unproject_position(interactable.global_position) - ($Panel.size/2)

func _hide_prompt(node: Interactable) -> void:
	self.visible = false

func _prep_prompt(node: Interactable) -> void:
	interactable = node
	_set_can_interact(true)
	self.visible = true

func _set_can_interact(value: bool) -> void:
	can_interact = value
