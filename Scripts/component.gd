class_name Component extends Node

@export var target: Node

func _is_target_null(node) -> void:
	if node == null:
		printerr(self, "No target found.")
		
		process_mode = Node.PROCESS_MODE_DISABLED
