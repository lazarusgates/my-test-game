extends Node2D

@onready var inter_area = $InterArea

func _on_inter_area_trigger_interact(event) -> void:
	if Dialogic.current_timeline == null:
		Dialogic.start('tvinteract')
		get_viewport().set_input_as_handled()
