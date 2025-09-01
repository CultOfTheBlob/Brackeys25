extends CharacterBody2D

@export var player : CharacterBody2D

@export var health : float = 15
@export var speed : float = 150000

@export var hit_area : Area2D

@export var sprite : Sprite2D

var knockedback : bool = false
var in_range : bool = false
var random_direction : float

func _ready() -> void:
	randomize()
	random()

func _process(delta : float) -> void:
	if get_parent().get_parent().paused:
		return

	var direction = sign(round(random_direction - global_position.x))

	if direction < 0:
		rotation_degrees = 180
	elif direction > 0:
		rotation_degrees = 0
	
	if direction:
		velocity.x = direction * speed * delta
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = velocity.x / 5

	move_and_slide()


func random():
	while true:
		random_direction = randf_range(player.global_position.x - 1000, player.global_position.x + 1000)
		await get_tree().create_timer(1).timeout

func die():
	get_parent().get_parent().deaths += 1
	await get_tree().create_timer(0.1).timeout
	queue_free()
