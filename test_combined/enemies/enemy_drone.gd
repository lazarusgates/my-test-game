extends Node2D

var genre_type
var level
var strong_against
var weak_to

#stats
var attack: int = 40
var health: int = 75
var defense: int = 2
var speed: int = 30


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
	$enemy_level.text = level
	
	health = health * level
	$enemy_health.text = health
	
	attack = attack * level

func take_damage(type, damage_taken):
	var defended_damage = damage_taken - (damage_taken * (defense/200))
	if type == strong_against:
		health -= defended_damage * 0.5
	elif type == weak_to:
		health -= defended_damage * 2
	else:
		health -= defended_damage
	
	if health <= 0:
		die()
	else:
		$enemy_health.text = health

func deal_damage(turn, player_health):
	var damage_variation = randi_range(-20, 20)
	return(attack + damage_variation)

func return_speed():
	return(speed * level)

func die():
	print("here is where i would send exp and money")
	print("but i'm not doing that yet")
	queue_free()
