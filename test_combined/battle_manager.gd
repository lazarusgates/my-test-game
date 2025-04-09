extends Node2D

var enemy_drone_scene = preload("res://enemies/enemy_drone.tscn")

var num_enemies
var enemies = []
var turns
var selecting = false
var selected_enemy = 0

signal spawn_keys
signal return_to_menu

func _ready():
	num_enemies = 2
	for i in range(1, num_enemies+1):
		enemies.append(enemy_drone_scene.instantiate())
		enemies[i-1].set_enemy("rock", 1)
		self.add_child(enemies[i-1])
		enemies[i-1].global_position.y = 200
		enemies[i-1].global_position.x = i*300
		print("spawned enemy ", i)

func _input(event):
	if selecting:
		if num_enemies != 0:
			if event.is_action_pressed("selection_left"):
				change_selection("left")
			elif event.is_action_pressed("selection_right"):
				change_selection("right")
		
		if event.is_action_pressed("interact"):
			player_attack(selected_enemy)
			selecting = false
			enemies[selected_enemy].selected(false)

func selecting_enemy():
	selecting = true
	change_selection("init")

func player_attack(enemy):
	print("Attacking enemy ", enemy+1)
	spawn_keys.emit()

func change_selection(direction):
	if direction == "init":
		enemies[selected_enemy].selected(true)
	
	elif direction == "left":
		enemies[selected_enemy].selected(false)
		if selected_enemy == 0:
			selected_enemy = num_enemies - 1
		else:
			selected_enemy -= 1
		enemies[selected_enemy].selected(true)
			
	elif direction == "right":
		enemies[selected_enemy].selected(false)
		if selected_enemy == num_enemies - 1:
			selected_enemy = 0
		else:
			selected_enemy += 1
		enemies[selected_enemy].selected(true)

func _on_key_manager_finished_attack() -> void:
	return_to_menu.emit()


func _on_attack_button_pressed() -> void:
	selecting_enemy()
