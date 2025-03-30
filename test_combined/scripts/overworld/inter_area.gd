extends Area2D
class_name InterArea

#every interactable object should have this node as a child

var in_body = false

signal trigger_interact()

func _on_ready() -> void:
	in_body = false

func _on_body_entered(_body: Node2D) -> void:
	in_body = true

func _on_body_exited(_body: Node2D) -> void:
	in_body = false

#triggers the interact function in the parent node's script
func _input(event):
	if event.is_action_pressed("interact") and in_body:
		trigger_interact.emit()
