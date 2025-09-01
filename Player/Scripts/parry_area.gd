extends Area2D


@export var damage : float = 5

func _input(event : InputEvent) -> void:
	if event.is_action("parry") and not monitoring:
		parry()

func _on_area_entered(area : Area2D) -> void:
	if area.name == "HitArea":
		if area.attacking:
			area.get_parent().die()
			get_parent().health.change_health(+10)
			get_parent().sprite.material.set("shader_parameter/toggle", true)
			await get_tree().create_timer(0.2).timeout
			get_parent().sprite.material.set("shader_parameter/toggle", false)
			monitoring = false
		else:
			get_parent().health.change_health(-area.damage * 2)

func parry() -> void:
	monitoring = true
	await get_tree().create_timer(0.1).timeout
	monitoring = false
