extends Area2D


@export var damage : float = 5
@export var knockback : float = 10000

func _input(event : InputEvent) -> void:
	if get_parent().get_parent().paused:
		return

	if event.is_action("attack") and not monitoring:
		attack()

func _on_area_entered(area : Area2D) -> void:
	print(area.name)
	if area.name == "DamageArea":
			area.get_parent().sprite.modulate = Color.RED
			await get_tree().create_timer(0.1).timeout
			area.get_parent().sprite.modulate = Color.WHITE
			area.get_parent().health -= damage
			get_parent().health.change_health(+2)
			if area.get_parent().health <= 0:
				area.get_parent().die()
			area.get_parent().knockback(knockback, 2, global_position.x)


func attack() -> void:
	monitoring = true
	await get_tree().create_timer(0.7).timeout
	monitoring = false
