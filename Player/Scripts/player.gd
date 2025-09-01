extends CharacterBody2D


@export var speed : float = 250000.0
@export var jump_velocity : float = 4000.0
@export var dash_strength : float = 10000.0
@export var reload_time : float = 1.5

@export var left_eye : ColorRect
@export var right_eye : ColorRect

@export var dash_timer : Timer
@export var dash_cooldown : Timer

@export var health : TextureProgressBar

@export var sprite : Sprite2D

@export var label : Label

@export var camera : Camera2D

@export var attack_area : Area2D
@export var parry_area : Area2D

var dashing : bool = false
var can_dash : bool = true
var reloading : bool = false
var shooting : bool = false

var time : float = 0
var miliseconds : float = 0
var seconds : float = 0
var minutes : float = 0

func _process(delta : float) -> void:
	if get_parent().paused:
		return

	if health.health > 0:
		time += delta
		miliseconds = fmod(time, 1) * 100
		seconds = fmod(time, 60)
		minutes = fmod(time, 3600) / 60
		label.text = ("%02d:" % minutes) + ("%02d." % seconds) + ("%03d" % miliseconds)

	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		set_collision_mask_value(2, false)
		can_dash = false
		right_eye.color.a = 0
		dash_timer.start()
		sprite.modulate = Color.BLACK
		velocity.y = 0

	if not is_on_floor() and not dashing:
		velocity += get_gravity() * delta * 10

	if Input.is_action_just_pressed("jump") and is_on_floor() and not dashing:
		velocity.y -= jump_velocity

	var direction : float = Input.get_axis("move_left", "move_right")

	if direction < 0:
		rotation_degrees = 180
	elif direction > 0:
		rotation_degrees = 0

	if direction:
		if dashing:
			velocity.x = direction * dash_strength;
		else:
			velocity.x = direction * speed * delta
	else:
		if dashing:
			velocity.x = dash_strength;
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if get_parent().paused:
		return

	if event.is_action("shoot") and not reloading:
		camera.shake(30)
		var bullet : CharacterBody2D = preload("uid://dvfvyje5cfd5h").instantiate()
		for child in get_parent().get_node("Bullets").get_children():
			child.queue_free()
		get_parent().get_node("Bullets").add_child(bullet)
		bullet.global_position = global_position
		bullet.shooting = true
		shooting = true
		await get_tree().create_timer(0.1).timeout
		shooting = false
		reload()

func _on_dash_time_timeout() -> void:
	dash_cooldown.start()
	dashing = false
	sprite.modulate = Color.WHITE
	set_collision_mask_value(2, true)

func _on_dash_cooldown_timeout() -> void:
	can_dash = true
	right_eye.color.a = 1


func reload() -> void:
	left_eye.color.a = 0
	reloading = true
	await get_tree().create_timer(reload_time).timeout
	reloading = false
	left_eye.color.a = 1
