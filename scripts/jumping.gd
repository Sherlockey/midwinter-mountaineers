extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.y = -player.jump_impulse
	player.animation_player.play("jump")

func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if Input.is_action_pressed("move_left"):
		player.sprite_2d.flip_h = false
	if Input.is_action_pressed("move_right"):
		player.sprite_2d.flip_h = true

	if player.velocity.y >= 0:
		finished.emit(FALLING)
	if Input.is_action_pressed("flare"):
		finished.emit(FLARING)
	if Input.is_action_pressed("latch"):
		finished.emit(LATCHING)
