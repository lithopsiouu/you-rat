class_name CoyoteTime extends Component

## Tracks [param time] after [method CharacterBody3D.is_on_floor] returns [code]false[/code].

@export_subgroup("Coyote Settings")
@export var coyote_time: float = 0.2 ## Time that [param coyote] is [code]true[/code] for after [method CharacterBody3D.is_on_floor] returns false.
var coyote: bool = false ## Changes value when the [Timer] is started or emits [signal Timer.timeout].
var _on_floor_diff: bool = false ## Set to last tick value of [method CharacterBody3D.is_on_floor]

signal coyote_changed ## Returns value of [param coyote] when it changes.

func _physics_process(delta: float) -> void:
	if target.is_on_floor() != _on_floor_diff:
		if _on_floor_diff: 
			_start_coyote() # start coyote when leaving the ground ONLY
		else:
			_set_coyote(false)
	
	_on_floor_diff = target.is_on_floor()

## Calls [method CoyoteTime._set_coyote] and starts a [b]one-shot[/b] [Timer] with a length of [param coyote_time].
func _start_coyote():
	_set_coyote(true)
	await get_tree().create_timer(coyote_time).timeout
	_set_coyote(false)

## Sets [param coyote] and emits [signal coyote_changed].
func _set_coyote(value: bool) -> void:
	coyote = value
	coyote_changed.emit(coyote)
