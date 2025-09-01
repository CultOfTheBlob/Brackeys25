extends CharacterBody2D


@export var speed : float = 300.0
@export var damage : float = 5.0

var direction : Vector2

func _ready() -> void:
	kill()

func _process(delta : float) -> void:
	look_at(direction)
	velocity = direction * speed * delta

	move_and_slide()

func _on_bullet_area_body_entered(body : Node2D) -> void:
	if body.name == "Player":
		body.sprite.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		body.sprite.modulate = Color.WHITE
		body.health.change_health(-damage)
	queue_free()


func kill() -> void:
	await get_tree().create_timer(3).timeout
	queue_free()
