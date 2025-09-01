extends Area2D


@export var damage : int = 5

var shooting : bool = false

var player : Node2D

var in_range : bool = false

func _process(_delta : float) -> void:
	if player:
		if in_range and not shooting:
			shoot()

func _on_body_entered(body : Node2D) -> void:
	if body.name == "Player":
		in_range = true
		player = body

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		in_range = false


func shoot() -> void:
	if in_range:
		shooting = true
		var spit : CharacterBody2D = preload("uid://bduxs4ujr7nom").instantiate()
		get_parent().get_parent().add_child(spit)
		spit.global_position = global_position
		spit.direction = player.global_position - spit.global_position
		await get_tree().create_timer(2).timeout
		shooting = false
