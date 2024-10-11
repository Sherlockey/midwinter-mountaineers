extends PlayerState


func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("fall")

func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	player.velocity.x = move_toward(player.velocity.x, player.speed * input_direction_x + player.wind_push, player.acceleration * delta)
	
	player.velocity.y += player.gravity * delta * player.gravity_falling_multiplier
	
	player.move_and_slide()
	
	if Input.is_action_pressed("move_left"):
		player.scale.x = player.scale.y * 1
	if Input.is_action_pressed("move_right"):
		player.scale.x = player.scale.y * -1

	if Input.is_action_pressed("rope"):
		finished.emit(ROPE_CASTING)
	if Input.is_action_pressed("flare") and player.can_flare:
		finished.emit(FLARING)
	if Input.is_action_pressed("latch") and player.can_latch:
		finished.emit(LATCHING)
	if Input.is_action_just_pressed("jump") and player.coyote_jump_timer.time_left > 0.0:
		finished.emit(JUMPING)
		player.coyote_jump_timer.stop()
	if player.is_on_floor():
		player.can_latch = true
		if is_equal_approx(input_direction_x, 0.0):
			finished.emit(IDLE)
		else:
			finished.emit(RUNNING)


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_down"):
		player.set_collision_mask_value(6, false) # Disable cloud mask
		if not player.drop_through_timer.is_stopped():
			player.drop_through_timer.stop()
		player.drop_through_timer.start()
