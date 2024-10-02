extends PlayerState


func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("jump")
	if data:
		if data.get("jump") == false:
			return
	player.velocity.y = -player.jump_impulse


func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if Input.is_action_pressed("move_left"):
		player.scale.x = player.scale.y * 1
	if Input.is_action_pressed("move_right"):
		player.scale.x = player.scale.y * -1

	if player.velocity.y >= 0:
		finished.emit(FALLING)
	if Input.is_action_pressed("rope"):
		finished.emit(ROPE_CASTING)
	if Input.is_action_pressed("flare") and player.can_flare:
		finished.emit(FLARING)
	if Input.is_action_pressed("latch") and player.can_latch:
		finished.emit(LATCHING)
