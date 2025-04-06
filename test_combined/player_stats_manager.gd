extends Node2D

var base_health = 200
var base_defense = 5
var base_speed = 20

var player_health
var player_level
var player_defense
var player_speed

var money
var exp

#this function should only be run once per save
func game_start():
	player_health = 200
	player_level = 1
	player_defense = 5
	player_speed = 20

	money = 0
	exp = 0

func add_exp(earned_exp: int):
	exp += earned_exp
	if exp >= 1000 * player_level:
		level_up()
		exp = 0

func level_up():
	player_level += 1
	player_health = player_level * base_health
	player_speed = player_level * base_speed
	player_defense = player_level * base_defense

func take_damage(damage: int):
	player_health -= damage - (damage * (player_defense/200))
	return(player_health)
	if player_health <= 0:
		die()

func die():
	print("bro you lost the game")
