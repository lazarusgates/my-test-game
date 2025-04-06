extends Node2D

var enemy_drone_scene = preload("res://enemies/enemy_drone.tscn")

var num_enemies
var enemies = []
var turns

func _ready():
	num_enemies = randi_range(1, 3)
	for i in range(1, num_enemies):
		enemies[i] = enemy_drone_scene.instantiate()
		enemies[i].set_enemy("rock", 1)
		enemies[i].global_position.y = 200
		enemies[i].global_position.x = i*300
