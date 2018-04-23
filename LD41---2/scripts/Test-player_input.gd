extends KinematicBody2D

const ACCELERATION = 600
const DECELERATION = 300
const MAX_SPEED = 500

var input_direction = 0
var direction = 0
var speed = Vector2()
var velocity = Vector2()

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	if input_direction:
		direction = input_direction
	
	if Input.is_action_pressed("move_left"):
		input_direction = -1
	elif Input.is_action_pressed("move_right"):
		input_direction = 1
	else:
		input_direction = 0
	
	if input_direction == - direction:
		speed.x /= 3
	if input_direction:
		speed.x += ACCELERATION * delta
	else:
		speed.x -= DECELERATION * delta
	speed.x = clamp(speed.x, 0, MAX_SPEED)
	velocity = Vector2(speed.x * delta * direction, 0)
	var movement_remainder = move(velocity)
