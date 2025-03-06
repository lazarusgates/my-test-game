extends Control

func _ready():
	var attackButton = $battle_choices/HBoxContainer/attack_button
	
	attackButton.grab_focus()
