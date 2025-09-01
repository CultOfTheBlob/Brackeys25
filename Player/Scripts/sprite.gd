extends Sprite2D


@export var player : CharacterBody2D;

func _process(_delta: float) -> void:
	if player.dashing:
		modulate = Color.BLACK
	else:
		modulate = Color.WHITE
