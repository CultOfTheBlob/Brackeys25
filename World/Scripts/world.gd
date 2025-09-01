extends Node2D


@onready var fly_enemy = preload("uid://hwltm8avd2oe")
@onready var slim_enemy = preload("uid://c5qor8hrcwqf5")

@export var player : CharacterBody2D

@export var min_height : float
@export var max_height : float

@export var edge_right : float
@export var edge_left : float

@export var padding_right : float
@export var padding_left : float

@export var fly_count : int
@export var slim_count : int

var wave : int = 1
var deaths : int = 0

var paused : bool = false

var tutorial_page : int = 1

func _ready() -> void:
	get_node("StartMenu").show()
	pause()

func _process(_delta : float) -> void:
	if player.health.health <= 0:
		pause()
		get_node("EndScreen/VBoxContainer/TimerMargin/TimerLabel").text = player.label.text
		get_node("EndScreen").show()

	if deaths == (slim_count * wave) + (fly_count * wave):
		wave += 1
		deaths = 0
		spawner()

func _input(event: InputEvent) -> void:
	if event.is_action("pause"):
		get_node("PauseMenu/VBoxContainer/TimerMargin/TimerLabel").text = player.label.text
		get_node("PauseMenu").show()
		pause()

func _on_restart_button_pressed() -> void:
	for child in get_node("Enemies").get_children():
		child.queue_free()

	play()

func _on_resume_button_pressed() -> void:
	get_node("PauseMenu").hide()
	player.get_node("CanvasLayer").show()
	Engine.time_scale = 1
	paused = false

func _on_play_button_pressed() -> void:
	play()

func _on_tutorial_button_pressed() -> void:
	get_node("TutorialMenu").show()
	get_node("TutorialMenu/ButtonLayer").show()
	get_node("TutorialMenu/Layer1").show()
	get_node("TutorialMenu/Layer2").show()
	get_node("TutorialMenu/Layer3").show()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_next_button_pressed() -> void:
	match tutorial_page:
		1:
			get_node("TutorialMenu/Layer1").layer = 1
			tutorial_page = 2
		2:
			get_node("TutorialMenu/Layer2").layer = 1
			get_node("TutorialMenu/ButtonLayer/Margin/NextLabel").text = "Back"
			tutorial_page = 3
		3:
			get_node("TutorialMenu/Layer1").layer = 3
			get_node("TutorialMenu/Layer2").layer = 2
			get_node("TutorialMenu/Layer3").layer = 1

			get_node("TutorialMenu/ButtonLayer/Margin/NextLabel").text = "Next"

			get_node("TutorialMenu").hide()
			get_node("TutorialMenu/ButtonLayer").hide()
			get_node("TutorialMenu/Layer1").hide()
			get_node("TutorialMenu/Layer2").hide()
			get_node("TutorialMenu/Layer3").hide()
			tutorial_page = 1


func pause():
	player.get_node("CanvasLayer").hide()
	Engine.time_scale = 0
	paused = true

func play():
	get_node("StartMenu").hide()
	get_node("PauseMenu").hide()
	get_node("EndScreen").hide()
	player.get_node("CanvasLayer").show()

	Engine.time_scale = 1
	wave = 1
	deaths = 0
	paused = false

	player.position = Vector2(0, -100)
	player.health.health = player.health.max_health
	player.time = 0
	player.dashing = false
	player.can_dash = true
	player.reloading = false
	player.shooting = false

	spawner()

func spawner() -> void:
	var slim_enemies : float = slim_count * wave
	while slim_enemies > 0:
		var spawn_right : float = randf_range(edge_right, edge_right - padding_right)
		var spawn_left : float = randf_range(edge_left, edge_left - padding_left)
		var direction : int = randi_range(1, 2)

		if direction == 1:
			var enemy = slim_enemy.instantiate()
			enemy.player = player
			get_node("Enemies").add_child(enemy)
			enemy.global_position.x = spawn_right
			enemy.global_position.y = player.global_position.y
		elif direction == 2:
			var enemy = slim_enemy.instantiate()
			enemy.player = player
			get_node("Enemies").add_child(enemy)
			enemy.global_position.x = spawn_left
			enemy.global_position.y = player.global_position.y

		slim_enemies -= 1

	var fly_enemies : int = fly_count * wave
	while fly_enemies > 0:
		var spawn_right : float = randf_range(edge_right, edge_right - padding_right)
		var spawn_left : float = randf_range(edge_left, edge_left - padding_left)
		var direction : int = randi_range(1, 2)

		var height : float = randf_range(min_height, max_height)

		if direction == 1:
			var enemy = fly_enemy.instantiate()
			enemy.player = player
			get_node("Enemies").add_child(enemy)
			enemy.global_position.x = spawn_right
			enemy.global_position.y = player.global_position.y - height
		elif direction == 2:
			var enemy = fly_enemy.instantiate()
			enemy.player = player
			get_node("Enemies").add_child(enemy)
			enemy.global_position.x = spawn_left
			enemy.global_position.y = player.global_position.y - height

		fly_enemies -= 1
