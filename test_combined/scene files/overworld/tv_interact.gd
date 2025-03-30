extends Node2D

@onready var inter_area = $InterArea

const lines: Array[String] = [
	"It's a TV store. The screens are playing
	live from The Speaker's channel.",
	"Not that there's any other channels to watch",
	"The show on right now is \"Confessionals!\", 
	where you can confess your transgressions to the Speaker 
	in front of a live audience.",
	"\"...It was an impulse decision! I don't even know why I did it!\"",
	"\"An impulse that lead you to mutilating yourself not once, but twice?\"",
	"\"Y-Yes! It was... an impulse...\"",
	"\"Lying is an indictment worth 200 points. We'll add it to your total.\"",
	"This has always been your least favorite show."
]

func _on_inter_area_trigger_interact() -> void:
	print("interacted with tv")
