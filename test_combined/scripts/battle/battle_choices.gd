extends Control

func _on_run_button_pressed() -> void:
	print('Attempting to run!')

func _on_battle_manager_return_to_menu() -> void:
	self.show()


func _on_attack_button_pressed() -> void:
	self.hide()


func _on_battle_manager_toggle_menu() -> void:
	self.show()
