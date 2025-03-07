extends Control

func _ready():
	self.hide()

func _on_attack_button_pressed() -> void:
	self.show()
