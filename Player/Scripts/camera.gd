extends Camera2D

@export var shake_fade : float = 5

var shake_strength : float = 0

func _ready() -> void:
	randomize()

func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)

		offset = Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))


func shake(random_strength : float) -> void:
	print("HI")
	shake_strength = random_strength
