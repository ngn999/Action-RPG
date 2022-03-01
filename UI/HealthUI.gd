extends Control

var hearts = 4 setget set_hearts

var max_hearts =4 setget set_max_hearts

onready var playerHeartFull = $PlayerHeartFull
onready var playerHeartEmpty = $PlayerHeartEmpty

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if playerHeartFull != null:
		playerHeartFull.rect_size.x = hearts * 15

func set_max_hearts(value):
	max_hearts = max(1, value)
	self.hearts = min(max_hearts, hearts)
	if playerHeartEmpty != null:
		playerHeartEmpty.rect_size.x = max_hearts * 15
	
func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
# warning-ignore:return_value_discarded
	PlayerStats.connect("health_changed", self, "set_hearts")
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
