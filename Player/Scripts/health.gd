extends TextureProgressBar


@export var max_health : float = 100

var health : float


func _ready() -> void:
	health = max_health
	value = max_health


func change_health(amount : int):
	health += amount
	health = clamp(health, 0, max_health)
	value = health
