extends Node2D
var enemy_drone_scene = preload("res://enemies/enemy_drone.tscn")

var num_enemies
var enemies = {}
var order = []
var turns
var selecting = false
var selected_enemy = 1

var rewarded_xp = 0
var rewarded_money = 0

signal spawn_keys
signal return_to_menu

func _ready():
	selected_enemy = 1
	num_enemies = randi_range(1, 5)
	for i in range(1, num_enemies+1):
		enemies[i] = enemy_drone_scene.instantiate()
		enemies[i].set_enemy("rock", 1, i)
		self.add_child(enemies[i])
		enemies[i].global_position.y = 200
		enemies[i].global_position.x = 200 * i
	print("num enemies: ", len(enemies))
	calc_order()

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

func calc_order():
	#calculate the order of the enemies
	#sorts order in DESCENDING order i.e. fastest is first
	var idx = 1
	for i in range(1, len(enemies)+1):
		while idx <= len(enemies):
			print("this iteration's speed: ", enemies[i].return_speed())
			if order.is_empty():
				print("first entry is ", enemies[i].return_speed())
				order.append(idx)
				print("first entry order: ", order)
				break
			elif idx == len(order):
				print("current slowest: ", enemies[i].return_speed())
				order.append(i)
				break
			elif enemies[i].return_speed() >= enemies[order[idx-1]].return_speed():
				order.insert(idx-1, i)
				print(i, "th iteration order: ", order)
				break
			else:
				idx += 1
	
	#insert the player's position in the turn order
	if PlayerStatsManager.player_speed >= enemies[order[0]].return_speed():
		order.insert(0, -1)
		print("player is fastest: ", order)
	elif PlayerStatsManager.player_speed <= enemies[order[len(order)-1]].return_speed():
		order.append(-1)
		print("player is slowest: ", order)
	else:
		idx = 1
		while idx <= len(order):
			if PlayerStatsManager.player_speed >= enemies[order[idx-1]].return_speed():
				order.insert(idx-1, -1)
				break
			else:
				idx += 1
	print(order)

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
			if selected_enemy == 1:
				selected_enemy = num_enemies
			else:
				selected_enemy -= 1
			enemies[selected_enemy].selected(true)
				
		elif direction == "right":
			enemies[selected_enemy].selected(false)
			if selected_enemy == num_enemies:
				selected_enemy = 1
			else:
				selected_enemy += 1
			enemies[selected_enemy].selected(true)

func kill_enemy():
	#calculate experience and money dropped by dying enemy
	rewarded_xp += enemies[selected_enemy].return_xp()
	rewarded_money += enemies[selected_enemy].return_money()
	print("total xp: ", rewarded_xp)
	print("total money: ", rewarded_money)
	
	#kill the enemy instance
	enemies[selected_enemy].die()
	
	#remove dead enemy from enemies dict
	enemies.erase(selected_enemy)
	num_enemies -= 1
	selected_enemy = 1
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
