extends Control

@onready var name_left_box = $name_box_left
@onready var name_left_text = $name_box_left/Label

@onready var name_right_box = $name_box_right
@onready var name_right_text = $name_box_right/Label

@onready var dialogue_box = $dialogue_box/RichTextLabel

var showing = false

func play_dialogue(line: String):
	if not showing:
		self.show()
		showing = true
	dialogue_box.text = line

func set_speaker(speaker: String, side: String):
	#checks what side the speaker is on and only shows that name box
	if side == "left":
		name_right_box.hide()
		name_left_text.text = speaker
		name_left_box.show()
	elif side == "right":
		name_left_box.hide()
		name_right_text.text = speaker
		name_right_box.show()

#reset the name boxes if there is no speaker
func reset_speaker():
	name_left_text.text = ""
	name_right_text.text = ""
	name_left_box.hide()
	name_right_box.hide()

#deletes the instanced dialogue box after its text is finished
func end_dialogue():
	queue_free()
