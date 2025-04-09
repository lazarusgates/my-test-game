extends Node2D

var base_health = 200
var base_defense = 5
var base_speed = 20

var player_health = base_health
var player_level = 1
var player_defense = base_defense
var player_speed = base_speed

var player_money = 0
var player_xp = 0

#this function should only be run once per save
func game_start():
	player_health = 200
	player_level = 1
	player_defense = 5
	player_speed = 20

	player_money = 0
	player_xp = 0

func add_xp(earned_xp: int):
	player_xp += earned_xp
	if player_xp >= 1000 * player_level:
		level_up()
		player_xp = 0

func level_up():
	player_level += 1
	player_health = player_level * base_health
	player_speed = player_level * base_speed
	player_defense = player_level * base_defense

func take_damage(damage: int):
	player_health -= damage - (damage * (player_defense/200))
	if player_health <= 0:
		die()
	else:
		return(player_health)

func die():
	print("bro you lost the game")
