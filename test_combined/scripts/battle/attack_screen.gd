extends Control

var attacking = false
var key_manager_scene = preload("res://key_manager.tscn")


func _ready():
	self.hide()

func _on_attack_button_pressed() -> void:
	if not attacking:
		attacking = true
		self.show()

func _on_battle_manager_return_to_menu() -> void:
	attacking = false
	self.show()
