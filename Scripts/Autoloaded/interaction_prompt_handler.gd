extends CanvasLayer

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var cam: Camera3D = get_viewport().get_camera_3d()
var interactor: Interactor
var interactable: Interactable
var can_interact: bool = false
var interaction_time: float = 0.0

func _ready() -> void:
	await player.find_child("Interactor")
	interactor = player.find_child("Interactor")
	
	interactor.area_entered.connect(_prep_prompt)
	interactor.area_exited.connect(_hide_prompt)

func _process(delta: float) -> void:
	if can_interact:
		$Panel.position = cam.unproject_position(interactable.global_position) - ($Panel.size/2)
	
		if interaction_time > 0.0:
			%TextureProgressBar.value = 100 - ((interactable.interact_timer.time_left / interaction_time) * 100)

func _hide_prompt(node: Interactable) -> void:
	self.visible = false
	_hide_progress_bar(false)
	%TextureProgressBar.value = 0.0
	interaction_time = 0.0

func _prep_prompt(node: Interactable) -> void:
	interactable = node
	_get_interaction_timed(interactable)
	_set_can_interact(true)
	self.visible = true

func _set_can_interact(value: bool) -> void:
	can_interact = value

func _get_interaction_timed(node: Interactable) -> void:
	print(node.interact_time)
	if node.interact_time > 0.0:
		_hide_progress_bar(true)
		%TextureProgressBar.value = 0.0
		interaction_time = node.interact_time
		node.interaction_began.connect(_show_bar)
		node.interaction_interrupted.connect(_hide_bar)

func _hide_bar() -> void:
	%TextureProgressBar.visible = false

func _show_bar() -> void:
	%TextureProgressBar.visible = true

func _hide_progress_bar(value: bool) -> void:
	%TextureProgressBar.visible = value
