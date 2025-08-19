extends Node2D

@onready var player_scene = load("res://scene files/overworld/walk_player.tscn")

var instanced_player

signal take_control
signal give_control

func _ready():
	EncManager.saved_position = Vector2(248, 248)
	instanced_player = player_scene.instantiate()
	self.add_child(instanced_player)
	instanced_player.end_control()
	
	var tween = get_tree().create_tween()
	instanced_player.play_animation("left")
	tween.tween_property(instanced_player, "position", Vector2(-350, 248), 1)
	await tween.finished
	instanced_player.stop_animation()
	tween.kill()
	
	instanced_player.play_animation("right")
	instanced_player.stop_animation()
	await get_tree().create_timer(1).timeout
	
	tween = get_tree().create_tween()
	instanced_player.play_animation("right")
	tween.tween_property(instanced_player, "position", Vector2(-400, 248), 1)
	await tween.finished
	instanced_player.stop_animation()
	tween.kill()
	
	await get_tree().create_timer(1).timeout
	
	tween = get_tree().create_tween()
	instanced_player.play_animation("right")
	tween.tween_property(instanced_player, "position", Vector2(-450, 248), 1)
	await tween.finished
	instanced_player.stop_animation()
	tween.kill()
	
	#this is where jenny would jump in but i don't have jenny sprites rn so we'll skip that
	
	Dialogic.start("pretutorial")
