extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")

var active_area = null
var can_interact = true

func register_area(area: InterArea):
	active_area = area

func unregister_area(area: InterArea):
	if area != active_area:
		active_area = null

func _input(event):
	if event.is_action_pressed("interact") and can_interact:
		if active_area != null:
			can_interact = false
			
			await active_area.interact.call()
			
			can_interact = true
