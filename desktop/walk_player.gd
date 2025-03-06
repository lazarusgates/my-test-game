extends CharacterBody2D


@export var speed = 300

func _ready():
	$AnimatedSprite2D.animation = "down"

func _physics_process(delta):
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
	
	#Determine if animation should be playing or not
	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	#Move the character
	move_and_slide()
		
	
