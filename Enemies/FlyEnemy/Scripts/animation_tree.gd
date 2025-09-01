extends AnimationTree


@export var enemy : CharacterBody2D

func _process(_delta: float) -> void:
	var direction : float = enemy.velocity.normalized().x

	if direction != 0:
		self.set("parameters/Fly/blend_position", direction)
		self.set("parameters/Shoot/blend_position", direction)
