extends KinematicBody2D
# s = v0 * t + 1/2 * a * (t ^ 2)
# v = v0 + at
const MAX_SPEED = 80
const ACCELERATION = 500
const FRICTION = 500
var velocity = Vector2.ZERO

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	input_vector = input_vector.normalized()
	
	if (input_vector != Vector2.ZERO):
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	print("velocity: ", velocity)
	move_and_collide(velocity * delta)
