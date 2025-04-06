extends Node2D

@onready var key_scene = preload("res://key.tscn")

var keys = []
var song_dict = {
	"Basic Pop Attack" : [["mid_C", 500, 0] , ["E", 500, 1000] , ["G", 500, 1500] , ["hi_C", 500, 2000]],
	"Basic Rock Attack": [["mid_C", 500, 500] , ["D", 500, 1000] , ["E", 500, 1500] , ["F", 500, 2000], ["G", 500, 2500]]
}
var hit_dict = {
	"Basic Pop Attack": 50,
	"Basic Rock Attack": 75
}

signal return_to_menu
signal first_key_pressed

var song_triggered = false
var played = {}

var time_since_note_start


func _on_attack_screen_spawn_keys() -> void:
	print("show keys")
	for i in range(0, 8):
		keys.append(key_scene.instantiate())
		self.add_child(keys[i])
		keys[i].global_position.x = 50 + (135 * i)
		keys[i].global_position.y = 340
		self.first_key_pressed.connect(keys[i]._on_first_key_pressed)
	
	keys[0].set_note("mid_C", "S", false)
	keys[1].set_note("D", "D")
	keys[2].set_note("E", "F")
	keys[3].set_note("F", "G", false)
	keys[4].set_note("G", "H")
	keys[5].set_note("A", "J")
	keys[6].set_note("B", "K")
	keys[7].set_note("hi_C", "L", false)

func song_began(time):
	time_since_note_start = time
	song_triggered = true
	first_key_pressed.emit()
	$Timer.start()

func add_note(note, note_length, time_since_song_start):
	played[len(played) + 1] = [note, note_length, time_since_song_start - time_since_note_start]

func _on_timer_timeout() -> void:
	check_song()

func check_song():
	var song_played
	var correct
	for song in song_dict:
		if len(song_dict[song]) == len(played):
			correct = true
			for i in range(0, len(played)):
				if song_dict[song][i][0] != played[i+1][0]:
					correct = false
			if correct == true: 
				song_played = song
				played_song(song_played)
				return
	deal_damage("fumble", 20)
	

func played_song(song):
	print(song)
	deal_damage(song, calc_damage(song))
	pass

func calc_damage(song):
	var dif
	var damage = hit_dict[song]
	for i in range(0, len(song_dict[song])):
		dif = song_dict[song][i][1] - played[i+1][1]
		if dif <= 50 and dif >= -50:
			print("Perfect note!")
		elif dif <= 150 and dif >= -150:
			damage -= damage * 0.05
			print("Good note!")
		elif dif <= 300 and dif >= -300:
			damage -= damage * 0.10
			print("Okay note!")
		else:
			damage -= damage * 0.25
			print("Bad note!")
		print(damage)
	return damage

func deal_damage(song, damage):
	$song_label.text = "Song Played: " + song
	await get_tree().create_timer(1.5).timeout
	$damage_label.text = "Damage Done: %d" % [damage]
	await get_tree().create_timer(1.5).timeout
	end_attack()

func end_attack():
	for key in keys:
		key.delete()
	$song_label.text = ""
	$damage_label.text = ""
	keys.clear()
	played.clear()
	song_triggered = false
	return_to_menu.emit()
