extends CharacterBody2D


@export var speed = 300
@onready var tilemap = get_tree().current_scene.find_child("testTileMap")

var encounterable = false
var distance_since_encounter = 0.0
var step_size = 5

func _ready():
	$AnimatedSprite2D.animation = "down"
	position = EncManager.saved_position

func _physics_process(_delta):
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
		update_tile()
		if encounterable:
			distance_since_encounter += 1
			print(distance_since_encounter / step_size)
			print(EncManager.encounter_number)
			if distance_since_encounter / step_size >= EncManager.encounter_number:
				set_physics_process(false)
				$AnimatedSprite2D.stop()
				EncManager.save_player_data(self)
				EncManager.change_scene()
	else:
		$AnimatedSprite2D.stop()
	
	#Move the character
	move_and_slide()
		

func update_tile():
	var tiledata = tilemap.get_cell_tile_data(tilemap.local_to_map(position))
	if tiledata:
		if encounterable != tiledata.get_custom_data("trigEnc"):
			distance_since_encounter = 0.0
		encounterable = tiledata.get_custom_data("trigEnc")
