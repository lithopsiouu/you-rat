class_name Interactable extends Area3D

## An [Interactable] that has an [param activated] state.
## Can be activated with an [Interactor].

@export var activation_state: bool = false ## State of the [Interactable].
var activated: bool ## State of the [Interactable].
var can_interact: bool = true ## Whether or not the [Interactable] can [method Interactable.activate].

@export_category("Settings")

@export_group("Flags")
@export var one_time: bool = false ## If the [Interactable] is a toggle.
@export var self_trigger: bool = false ## Triggers the [Interactable] after [param cooldown_time].[br]Does [b]NOT[/b] work if [param cooldown_time] is less than or equal to [code]0[/code].
@export var reset_on_cooldown: bool = false ## Toggles [param activated] on cooldown end.[br]Does [b]NOT[/b] work if [param cooldown_time] is less than or equal to [code]0[/code].

@export_group("Time")
@export var interact_time: float = 0.0 ## Length of time to hold the interaction.
@export var cooldown_time: float = 0.0 ## Time before interaction can be activated again.

@export_group("Requirements")
@export var required_state: bool = true ## State of [param required_interactions] necessary to activate
@export var required_interactions: Array[Interactable] = [] ## Required [Interactable] nodes to activate

var interact_timer: Timer
var cooldown_timer: Timer

## Initialize collisions, initialize timers, connect signals
func _ready() -> void:
	collision_layer = 9
	collision_mask = 10
	activated = activation_state
	
	if interact_time > 0.0: 
		interact_timer = Timer.new()
		interact_timer.wait_time = interact_time
		interact_timer.one_shot = true
		add_child(interact_timer)
		interact_timer.timeout.connect(_on_interact_timer_timeout)
		
	if cooldown_time > 0.0: 
		cooldown_timer = Timer.new()
		cooldown_timer.wait_time = cooldown_time
		cooldown_timer.one_shot = true
		add_child(cooldown_timer)
		cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _on_area_entered(area: Area3D) -> void:
	#print(area, "entered")
	if area is Interactor:
		area.interact.connect(_interact)

func _on_area_exited(area: Area3D) -> void:
	#print(area, "exited")
	if area is Interactor:
		area.interact.disconnect(_interact)


func _on_interact_timer_timeout() -> void:
	_activate(true)

func _on_cooldown_timer_timeout() -> void:
	can_interact = true
	
	if self_trigger:
		if one_time or cooldown_time <= 0.0:
			return
		_activate(true)
	elif reset_on_cooldown:
		_activate(activation_state, false)

## Sets value of [param activated].
func _activate(state: bool, cooldown: bool = true) -> void:
	if one_time:
		print(self, " state: ", state, " | last state: ", activated)
		activated = state
		can_interact = false
		cooldown = false
	else:
		print(self, " state: ", !activated, " | last state: ", activated)
		activated = !activated
	
	if cooldown_time > 0.0 and cooldown:
		cooldown_timer.start()
		can_interact = false
	

## Performs checks before [method Interactable._activate].
func _interact(value: bool) -> void:
	if can_interact == true:
		if _check_requirements():
			if interact_time > 0.0:
				if value:
					interact_timer.start()
				else:
					interact_timer.stop()
			elif value:
				_activate(!activated)

## Checks if [param required_interactions] matches [param required_state]. returns [code]true[/code] or [code]false[/code].
func _check_requirements() -> bool:
	var passed = false
	
	if required_interactions.size() > 0:
		passed = true
		for interaction in required_interactions:
			if interaction.activated != required_state:
				passed = false
	else:
		passed = true
	
	return passed
