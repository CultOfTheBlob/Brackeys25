extends Area2D


@export var damage : int = 5

var attacking : bool = false

var player : Node2D

var in_range : bool = false

func _process(_delta : float) -> void:
	if player:
		if not player.dashing and in_range and not attacking:
			attack()

func _on_body_entered(body : Node2D) -> void:
	if body.name == "Player":
		in_range = true
		player = body

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		in_range = false


func attack() -> void:
	attacking = true
	await get_tree().create_timer(1.0).timeout
	if in_range:
		player.health.change_health(-damage)
		player.sprite.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		player.sprite.modulate = Color.WHITE
	attacking = false
