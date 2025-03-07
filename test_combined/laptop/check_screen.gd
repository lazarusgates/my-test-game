extends Control
func _ready():
	self.hide()

func _on_check_button_pressed() -> void:
	self.show()
