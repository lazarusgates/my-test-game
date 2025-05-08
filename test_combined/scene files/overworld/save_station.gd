extends Node2D

@onready var inter_area = $InterArea

func _on_inter_area_trigger_interact(_event) -> void:
	if Dialogic.current_timeline == null:
		PlayerStatsManager.current_player_health = PlayerStatsManager.total_player_health
		Dialogic.start('savestation')
		get_viewport().set_input_as_handled()
