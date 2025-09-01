extends CharacterBody2D

@export var player : CharacterBody2D

@export var health : float = 30
@export var speed : float = 100000

@export var hit_area : Area2D

@export var sprite : Sprite2D

var knockedback : bool = false
var in_range : bool = false

func _process(delta : float) -> void:
	if get_parent().get_parent().paused:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction = sign(round(player.global_position.x - global_position.x))

	if direction < 0:
		rotation_degrees = 180
	elif direction > 0:
		rotation_degrees = 0
	
	if direction:
		if not knockedback:
			velocity.x = direction * speed * delta
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	if in_range:
		velocity.x = 0

	move_and_slide()

func _on_hit_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		in_range = true

func _on_hit_area_body_exited(body:Node2D) -> void:
	if body.name == "Player":
		in_range = false


func knockback(strength : float, duration : float, position_x : float) -> void:
	knockedback = true
	set_collision_mask_value(2, false)
	set_collision_layer_value(2, false)
	while duration > 0:
		velocity.x = strength * sign(global_position.x - position_x)
		move_and_slide()
		duration -= 1
		await get_tree().create_timer(0.05).timeout
	velocity.x = 0
	await get_tree().create_timer(0.2).timeout
	set_collision_mask_value(2, true)
	set_collision_layer_value(2, true)
	knockedback = false

func die():
	get_parent().get_parent().deaths += 1
	await get_tree().create_timer(0.1).timeout
	queue_free()
