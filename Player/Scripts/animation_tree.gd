extends AnimationTree


@export var player : CharacterBody2D

func _process(_delta: float) -> void:
	var direction : float = player.velocity.normalized().x
	var look_direction : float = Input.get_axis("look_left", "look_right")
	# var look_direction : float = player.get_global_mouse_position().normalized().x

	if direction != 0:
		self.set("parameters/Idle/blend_position", direction)
		self.set("parameters/Walk/blend_position", direction)
		self.set("parameters/Jump/blend_position", direction)
		self.set("parameters/Attack/blend_position", direction)
		self.set("parameters/Parry/blend_position", direction)
	if look_direction != 0:
		self.set("parameters/Shoot/blend_position", look_direction)
