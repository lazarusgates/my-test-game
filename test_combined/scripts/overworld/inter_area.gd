extends Area2D

class_name InterArea

@export var action_name: String = "interact"

var interact: Callable = func():
	pass


func _on_body_entered(body: Node2D) -> void:
	InterManager.register_area(self)


func _on_body_exited(body: Node2D) -> void:
	InterManager.unregister_area(self)
