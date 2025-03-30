extends Node

@onready var dialogue_box_scene = preload("res://dialogue/dialogue_ui.tscn")

#grabs player so we know where to put the instanced dialogue box
@onready var player = get_tree().get_nodes_in_group("player")[0]

var dialogue_box
var currently_speaking = false
var spliced
var speaker
var side
var line

signal hit_next()

func _ready():
	currently_speaking = false

#begin the playing of dialogue
func trigger_dialogue(lines: Array):
	#if there is already a dialogue box open we will not open another one
	if currently_speaking:
		return
	
	currently_speaking = true
	
	#create an instance of the dialogue box to hold the text and put it in the right position
	dialogue_box = dialogue_box_scene.instantiate()
	get_tree().root.add_child(dialogue_box)
	dialogue_box.global_position.x = player.get_position().x - 620
	dialogue_box.global_position.y = player.get_position().y - 380
	
	play_dialogue(lines)

#sends each individual line to the instantiated dialogue box
func play_dialogue(lines: Array):
	for i in range(-1, lines.size()):
		#boxes without named speakers will not have |
		#so we know to have no name boxes
		if lines[i].find("|") == -1:
			dialogue_box.reset_speaker()
			line = lines[i]
		else:
			#splits the given line into the speaker's name, what side they stand on, and the spoken line
			spliced = lines[i].split("|", 5)
			speaker = spliced[0]
			side = spliced[1]
			line = spliced[2]
			dialogue_box.set_speaker(speaker, side)
		dialogue_box.play_dialogue(line)
		
		#wait for interact to be hit to begin the next line
		await hit_next
	end_dialogue()

func end_dialogue():
	dialogue_box.end_dialogue()
	currently_speaking = false

func _input(event):
	if event.is_action_pressed("interact") and currently_speaking:
		hit_next.emit()
