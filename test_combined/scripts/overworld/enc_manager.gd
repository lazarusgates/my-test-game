extends Node

var encounter_number
@export var battle_scene = load("res://scene files/battle/battle_screen.tscn")
var saved_position = Vector2(100,100)

func _ready():
	randomize()
	encounter_number = randi_range(10, 25)

func change_scene():
	get_tree().change_scene_to_packed(battle_scene)
	encounter_number = randi_range(10, 25)

func save_player_data(player):
	saved_position = player.position
