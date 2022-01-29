extends KinematicBody2D
# s = v0 * t + 1/2 * a * (t ^ 2)
# v = v0 + at
const MAX_SPEED = 80
const ACCELERATION = 500
const FRICTION = 500
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	input_vector = input_vector.normalized()
	
	if (input_vector != Vector2.ZERO):
		if input_vector.x > 0:
			animationPlayer.play("RunRight")
		else:
			animationPlayer.play("RunLeft")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationPlayer.play("RESET")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	# print("velocity: ", velocity)
	velocity = move_and_slide(velocity)
