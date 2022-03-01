extends KinematicBody2D
var knockback = Vector2.ZERO

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer
const EnemyDeathEffect = preload("res://Enemies/EnemyDeathEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 4

var velocity = Vector2.ZERO

enum {
	IDLE
	WANDER
	CHASE
}

var state = CHASE

func _ready():
	state = pick_rand_state([IDLE, WANDER])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()

		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_move_to_position(wanderController.target_position, delta)
			# if too close stop
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
		CHASE:
			# TODO: when it's too close, stop
			var player = playerDetectionZone.player
			if player != null:
				accelerate_move_to_position(player.global_position, delta)
			else:
				state = IDLE
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func update_wander():
	state = pick_rand_state([IDLE, WANDER])
	wanderController.start_timer(rand_range(1, 3))

func accelerate_move_to_position(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0 # make sure the bat's face is toward player

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func pick_rand_state(states):
	states.shuffle()
	return states.pop_front()

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 120
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)


func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position


func _on_Hurtbox_invincibility_ended():
	animationPlayer.play("Stop")

func _on_Hurtbox_invincibility_started():
	animationPlayer.play("Start")
