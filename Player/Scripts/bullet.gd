extends CharacterBody2D


@export var speed : float = 300000.0
@export var damage : float = 10.0

var shooting : bool = false
var direction : Vector2

func _process(delta : float) -> void:
	if shooting:
		var player_direction : float = Input.get_axis("move_left", "move_right")
		direction = (get_global_mouse_position() - position).normalized()
		# direction.x = Input.get_axis("look_left", "look_right")
		# direction.y = Input.get_axis("look_up", "look_down")
		look_at(direction)
		if direction == Vector2(0, 0):
			queue_free()
		velocity = direction * speed * delta
		if player_direction != 0:
			shooting = false
			queue_free()

	move_and_slide()

func _on_bullet_area_area_entered(area : Area2D) -> void:
	if area.name == "DamageArea":
		area.get_parent().sprite.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		area.get_parent().sprite.modulate = Color.WHITE
		area.get_parent().health -= damage
		if area.get_parent().health <= 0:
			area.get_parent().die()
		await get_tree().create_timer(0.1).timeout
		queue_free()
