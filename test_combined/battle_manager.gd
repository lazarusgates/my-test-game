extends Node2D

var enemy_drone_scene = preload("res://enemies/enemy_drone.tscn")

var num_enemies
var enemies = []
var turns
var selecting = false
var selected_enemy = 0

var rewarded_xp = 0
var rewarded_money = 0

signal spawn_keys
signal return_to_menu

func _ready():
	selected_enemy = 0
	num_enemies = randi_range(1, 5)
	for i in range(1, num_enemies+1):
		enemies.append(enemy_drone_scene.instantiate())
		enemies[i-1].set_enemy("rock", 1)
		self.add_child(enemies[i-1])
		enemies[i-1].global_position.y = 200
		enemies[i-1].global_position.x = 200 * i

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
	elif len(enemies) != 1:
		if direction == "left":
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

func kill_enemy():
		rewarded_xp += enemies[selected_enemy].return_xp()
		rewarded_money += enemies[selected_enemy].return_money()
		print("total xp: ", rewarded_xp)
		print("total money: ", rewarded_money)
		enemies[selected_enemy].die()
		for i in range(selected_enemy, len(enemies)-1):
			enemies[i] = enemies[i+1]
		enemies = enemies.slice(0, len(enemies)-1)
		num_enemies -= 1
		selected_enemy = 0
		if enemies.is_empty():
			battle_end()

func battle_end():
	PlayerStatsManager.add_xp(rewarded_xp)
	PlayerStatsManager.player_money += rewarded_money
	print("total xp: ", PlayerStatsManager.player_xp)
	print("total money: ", PlayerStatsManager.player_money)
	print("all enemies defeated: return to overworld")

func _on_key_manager_finished_attack(damage, type) -> void:
	enemies[selected_enemy].take_damage(damage, type)
	if enemies[selected_enemy].health <= 0:
		kill_enemy()
	return_to_menu.emit()


func _on_attack_button_pressed() -> void:
	selecting_enemy()
