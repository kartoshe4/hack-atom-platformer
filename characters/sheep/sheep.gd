extends CharacterBody2D

var speed = 0.0
var direction = 0
var old_direction = 1

const SLOWDOWN = 20.0
const ACCELERATION = 10.0
const MAX_SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# The uniformly accelerated motion
	direction = Input.get_axis("left", "right")
	if direction:
		speed += ACCELERATION * direction
		old_direction = direction
	elif speed / old_direction > 0:
		speed -= SLOWDOWN * old_direction
	
	# Maximum speed and full deceleration
	if speed * old_direction < ACCELERATION:
		speed = 0.0
	if speed * old_direction > MAX_SPEED:
		speed = MAX_SPEED * direction
	
	# flip
	$AnimatedSprite2D.flip_h = not(old_direction+1)
	
	if not(is_on_floor()):
		$AnimatedSprite2D.play("jump")
	elif int(speed) != 0:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("Idle")
	
	velocity.x = speed
	print(speed)
	move_and_slide()
