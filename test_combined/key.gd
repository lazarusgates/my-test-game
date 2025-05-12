extends Node2D

var note = "mid_C"
var song_triggered = false
var note_held = false
var start_loop = true

var note_time_start
var note_length

var song_time_start
var time_since_song_start


func _on_ready():
	self.first_key_pressed.connect(_on_first_key_pressed)
	

func set_note(key: String, input: String, black_key: bool = true):
	note = key
	$punch.stream = load("res://audio/key notes/" + key + "_punch.wav")
	$loop.stream = load("res://audio/key notes/" + key + "_loop.wav")
	$ColorRect/Label.text = input
	if not black_key:
		$black_key.hide()
	
func _process(_delta: float):
	if Input.is_action_pressed(note):
		if note_held == false:
			note_held = true
			note_time_start = Time.get_ticks_msec()
			$punch.play()
			
		if song_triggered == false:
			time_since_song_start = note_time_start
			song_triggered = true
			self.get_parent().song_began(note_time_start)
			
		if start_loop and not $loop.playing:
			$loop.play()
		
		$ColorRect.color = 'green'
	
	
	if Input.is_action_just_released(note):
		note_length = Time.get_ticks_msec() - note_time_start
		self.get_parent().add_note(note, note_length, note_time_start)
		$ColorRect.color = 'white'
		$punch.stop()
		$loop.stop()
		start_loop = false
		note_held = false

func _on_first_key_pressed():
	song_triggered = true

func delete():
	queue_free()


func _on_punch_finished() -> void:
	start_loop = true
