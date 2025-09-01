extends Area2D


@export var damage : int = 5

func _on_body_entered(body : Node2D) -> void:
	if body.name == "Player":
		if not body.dashing:
			body.health.change_health(-damage)
			body.sprite.modulate = Color.RED
			await get_tree().create_timer(0.1).timeout
			body.sprite.modulate = Color.WHITE
