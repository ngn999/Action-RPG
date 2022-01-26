extends KinematicBody2D
# s = v0 * t + 1/2 * a * (t ^ 2)
# v = v0 + at
const MAX_SPEED = 200
const ACCELERATION = 25
const FRICTION = 25
var velocity = Vector2.ZERO

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	input_vector = input_vector.normalized()
	
	if (input_vector != Vector2.ZERO):
		velocity += input_vector * ACCELERATION * delta
		
		# limit the length of the vector
		velocity = velocity.clamped(MAX_SPEED * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	print("velocity: ", velocity)
	move_and_collide(velocity)
