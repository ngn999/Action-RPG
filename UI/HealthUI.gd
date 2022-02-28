extends Control

var hearts setget set_hearts

var max_hearts setget set_max_hearts

onready var playerHeartFull = $PlayerHeartFull

func set_hearts(value):
	hearts = value
	hearts = clamp(hearts, 0, max_hearts)
	if playerHeartFull != null:
		playerHeartFull.rect_size.x = hearts * 15

func set_max_hearts(value):
	max_hearts = value
	
func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
