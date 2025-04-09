extends Control

@onready var attackButton = $battle_choices/HBoxContainer/attack_button

func _ready():
	attackButton.grab_focus()

func _on_battle_manager_return_to_menu() -> void:
	attackButton.grab_focus()
