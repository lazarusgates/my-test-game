extends Area2D
class_name InterArea

var in_body = false

signal trigger_interact(event)

func _on_ready() -> void:
	in_body = false

func _on_body_entered(_body: Node2D) -> void:
	if _body.is_in_group("player"):
		in_body = true

func _on_body_exited(_body: Node2D) -> void:
	if _body.is_in_group("player"):
		in_body = false

func _input(event):
	if event.is_action_pressed("interact") and in_body:
		trigger_interact.emit(event)
