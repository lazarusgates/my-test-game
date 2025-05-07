extends Control

@onready var attackButton = $battle_choices/HBoxContainer/attack_button

func _ready():
	attackButton.grab_focus()

func _on_battle_manager_toggle_menu() -> void:
	print("showing menu")
	attackButton.grab_focus()
	self.show()
