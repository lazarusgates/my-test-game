extends Node2D

var genre_type
var level
var strong_against
var weak_to

#stats
var attack: int = 20
var health: int = 75
var defense: int = 2
var speed: int = 30

var money = 50
var xp = 100

func set_enemy(type: String, enemy_level: int):
	genre_type = type
	match genre_type:
		"pop":
			strong_against = "punk"
			weak_to = "noise"
		"punk":
			strong_against = "rock"
			weak_to = "pop"
		"rock":
			strong_against = "alt"
			weak_to = "punk"
		"alt":
			strong_against = "noise"
			weak_to = "rock"
		"noise":
			strong_against = "pop"
			weak_to = "alt"
	
	
	$Sprite2D.texture = load("res://enemies/sprites/drone/" + type + ".png")
	$enemy_name.text = type + " Drone"
	
	level = enemy_level
	$enemy_level.text = str(level)
	
	health = health * level
	$enemy_health.text = str(health)
	
	attack = attack * level
	speed = (speed * level) + randi_range(-2*level, 2*level)

func selected(toggle: bool):
	if toggle:
		$selected_halo.show()
	else:
		$selected_halo.hide()

func take_damage(damage_taken, type):
	var defended_damage = damage_taken - (damage_taken * (defense/200))
	if type == strong_against:
		health -= defended_damage * 0.5
	elif type == weak_to:
		health -= defended_damage * 2
	else:
		health -= defended_damage
	
	$enemy_health.text = str(health)

func deal_damage(turn):
	var damage_variation = randi_range(-10, 10)
	return(attack + damage_variation)

func return_speed():
	return(speed * level)

func return_money():
	var variation = randi_range(-10*level/2, 10*level/2)
	return(money + variation)

func return_xp():
	var variation = randi_range(-10*level/2, 10*level/2)
	return(xp + variation)

func die():
	queue_free()
