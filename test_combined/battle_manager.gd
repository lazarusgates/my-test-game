extends Node2D
@onready var enemy_drone_scene = preload("res://enemies/enemy_drone.tscn")
@onready var health_label = $player/health_label
@onready var level_label = $player/level_label
@export var world = load("res://scene files/overworld/test_scene.tscn")

var num_enemies
var enemies = {}
var order = []
var turns = 0
var selecting = false
var selected_enemy = 1

var next_turn = false
var whose_turn = -1
var battle_finished = false

var rewarded_xp = 0
var rewarded_money = 0

signal spawn_keys
signal toggle_menu

func _ready():
	selected_enemy = 1
	#spawn a random number of test enemies
	num_enemies = randi_range(1, 1)
	for i in range(1, num_enemies+1):
		enemies[i] = enemy_drone_scene.instantiate()
		enemies[i].set_enemy("rock", 1)
		self.add_child(enemies[i])
		enemies[i].global_position.y = 200
		enemies[i].global_position.x = 200 * i
	
	#calculate the turn order based on speed
	calc_order()
	
	#initiate first turn
	next_turn = true

func _process(_delta):
	if PlayerStatsManager.player_health <= 0:
		battle_lost()

	if next_turn and not battle_finished:
		whose_turn += 1
		#roll over the turns if every entity has taken their turn that round
		if whose_turn >= len(order):
			print("next turn!")
			turns += 1
			whose_turn = 0
		
		#if the id in order is -1, it's the players turn
		#otherwise, if the order id hasn't been nulled, it's that enemies turn
		if order[whose_turn] == -1:
			next_turn = false
			toggle_menu.emit()
		elif typeof(enemies.get(order[whose_turn])) != TYPE_STRING:
			next_turn = false
			enemy_turn(order[whose_turn])

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

func enemy_turn(id):
	var damage = enemies[id].deal_damage(turns)
	print("enemy ", id, " attacks for ", damage, " damage!")
	PlayerStatsManager.take_damage(damage)
	health_label.text = str(PlayerStatsManager.player_health)
	next_turn = true

func calc_order():
	#calculate the order of the enemies
	#sorts order in DESCENDING order i.e. fastest is first
	var idx = 1
	for i in range(1, len(enemies)+1):
		while idx <= len(enemies):
			if order.is_empty():
				order.append(idx)
				break
			elif idx == len(order):
				order.append(i)
				break
			elif enemies[i].return_speed() >= enemies[order[idx-1]].return_speed():
				order.insert(idx-1, i)
				break
			else:
				idx += 1
	print(order)
	#insert the player's position in the turn order
	if PlayerStatsManager.player_speed >= enemies[order[0]].return_speed():
		order.insert(0, -1)
	elif PlayerStatsManager.player_speed <= enemies[order[len(order)-1]].return_speed():
		order.append(-1)
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
	print("Attacking enemy ", enemy)
	spawn_keys.emit()

func change_selection(direction):
	if direction == "init":
		enemies[selected_enemy].selected(true)
	elif len(enemies) != 1:
		if direction == "left":
			enemies[selected_enemy].selected(false)
			selected_enemy -= 1
			if selected_enemy < 1:
				selected_enemy = len(enemies)
			while true:
				if typeof(enemies[selected_enemy]) != TYPE_STRING:
					break
				selected_enemy -= 1
			enemies[selected_enemy].selected(true)
				
		elif direction == "right":
			enemies[selected_enemy].selected(false)
			selected_enemy += 1
			while true:
				if selected_enemy > len(enemies):
					selected_enemy = 1
				if typeof(enemies[selected_enemy]) != TYPE_STRING:
					break
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
	enemies[selected_enemy] = "dead"
	num_enemies -= 1
	print(enemies)
	selected_enemy = 1
	if num_enemies <= 0:
		battle_end()
	else:
		while true:
			if typeof(enemies[selected_enemy]) != TYPE_STRING:
				break
		
			selected_enemy += 1

func battle_end():
	PlayerStatsManager.add_xp(rewarded_xp)
	PlayerStatsManager.player_money += rewarded_money
	print("total xp: ", PlayerStatsManager.player_xp)
	print("total money: ", PlayerStatsManager.player_money)
	print("all enemies defeated: return to overworld")
	get_tree().change_scene_to_packed(world)
	battle_finished = true

func battle_lost():
	print("dieded")
	battle_finished = true

func _on_key_manager_finished_attack(damage, type) -> void:
	next_turn = true
	enemies[selected_enemy].take_damage(damage, type)
	if enemies[selected_enemy].health <= 0:
		kill_enemy()

func _on_attack_button_pressed() -> void:
	selecting_enemy()
