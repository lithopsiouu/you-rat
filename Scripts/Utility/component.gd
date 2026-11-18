class_name Component extends Node

## Allows for easy setup and verification of simple [Component] nodes.

@export var target: Node ## [Node] used for [Component] inheritors.

## Verifies if [param node] is not [code]null[/code].[br]
## If [param can_skip] is [code]true[/code], this will only print an [b]error[/b].
func _is_target_null(node: Variant, can_skip: bool = false) -> void:
	if node == null:
		printerr(self, "No target found.")
		
		if can_skip == false:
			process_mode = Node.PROCESS_MODE_DISABLED
