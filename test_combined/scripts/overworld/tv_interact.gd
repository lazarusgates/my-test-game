extends Node2D

@onready var inter_area = $InterArea
@onready var dialogue_manager = $"/root/DialogueManager"

const lines: Array[String] = [
	"It's a TV store. The screens are playing live from The Speaker's channel.",
	"Not that there's any other channels to watch.",
	"The show on right now is \"Confessionals with the Speaker!\", where you can confess your transgressions to the Speaker in front of a live audience.",
	"Stranger|left|\"...It was an impulse decision! I don't even know why I did it!\"",
	"The Speaker|right|\"An impulse that lead you to mutilating yourself not once, but twice? That's quite the long-lasting impulse. Especially to get through the pain.\"",
	"Stranger|left|\"Y-Yes, well... yes, I guess that's...\"",
	"The Speaker|right|\"Is that really the truth?\"",
	"Stranger|left|\"I... no.\"",
	"The Speaker|right|\"Tell us the real reason.\"",
	"Stranger|left|\"I just thought it would look cool. And I thought it wouldn't matter, because, it's just my ears, right?\"",
	"The Speaker|right|\"Remember what the Warden has decreed: you must settle for the body you have, and should never try to change it. Modification is a 2000 point transgression. Lying is another 200. We'll add both to your total.\"",
	"Stranger|left|\"I'm sorry...\"",
	"The crowd erupts into booing and jeers.",
	"This has always been your least favorite show."
]

func _on_inter_area_trigger_interact() -> void:
	dialogue_manager.trigger_dialogue(lines)
