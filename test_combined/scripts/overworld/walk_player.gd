extends CharacterBody2D


@export var speed = 300
@onready var tilemap = get_tree().current_scene.find_child("testTileMap")

var controlable = true
var encounterable = false
var distance_since_encounter = 0.0
var step_size = 5

func _ready():
	$AnimatedSprite2D.animation = "down"
	position = EncManager.saved_position
	Dialogic.timeline_started.connect(_on_timeline_started)
	Dialogic.timeline_ended.connect(_on_timeline_ended)

func _physics_process(_delta):
	if controlable:
		#Calculate vertical movement
		if Input.is_action_pressed("move_down"):
			velocity.y = speed
		elif Input.is_action_pressed("move_up"):
			velocity.y = -speed
		else:
			velocity.y = 0
		
		#Calculate horizontal movement
		if Input.is_action_pressed("move_right"):
			velocity.x = speed
		elif Input.is_action_pressed("move_left"):
			velocity.x = -speed
		else:
			velocity.x = 0
	
		#Choose animation depending on direction
		if velocity.y > 0:
			$AnimatedSprite2D.animation = "down"
		elif velocity.y < 0:
			$AnimatedSprite2D.animation = "up"
		elif velocity.x > 0:
			$AnimatedSprite2D.animation = "right"
		elif velocity.x < 0:
			$AnimatedSprite2D.animation = "left"
	
		#Determine if player is moving or not
		if velocity.length() > 0:
			$AnimatedSprite2D.play()
			
			#check if the player is on an encounter tile
			update_tile()
			if encounterable:
				distance_since_encounter += 1
			
				#trigger the encounter once the number of steps hits the random encounter number
				if distance_since_encounter / step_size >= EncManager.encounter_number:
					PlayerStatsManager.cur_area = tilemap.get_cell_tile_data(tilemap.local_to_map(position)).get_custom_data("area")
					end_control()
					EncManager.save_player_data(self)
					EncManager.change_scene()
		else:
			$AnimatedSprite2D.stop()
	
	#Move the character
	move_and_slide()
		

#update what tile the player is on
func update_tile():
	var tiledata = tilemap.get_cell_tile_data(tilemap.local_to_map(position))
	if tiledata:
		#if the player is unable to trigger an encounter, reset the distance counter
		if encounterable != tiledata.get_custom_data("trigEnc"):
			distance_since_encounter = 0.0
		
		#check if the tile can trigger encounters or not
		encounterable = tiledata.get_custom_data("trigEnc")

func _on_timeline_started():
	end_control()

func _on_timeline_ended():
	return_control()

func end_control():
	controlable = false
	velocity.y = 0
	velocity.x = 0
	$AnimatedSprite2D.stop()

func return_control():
	controlable = true

func play_animation(animation):
	$AnimatedSprite2D.animation = animation
	$AnimatedSprite2D.play()

func stop_animation():
	$AnimatedSprite2D.stop()
