extends Node2D

onready var animatedSprite = $AnimatedSprite
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	animatedSprite.frame = 0
	animatedSprite.play("Animate")

func _on_AnimatedSprite_animation_finished():
	queue_free()
