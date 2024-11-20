extends PlayerState


func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("run")


func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis(player.move_left_action, player.move_right_action)
	player.velocity.x = move_toward(player.velocity.x, player.speed * input_direction_x + player.wind_push, player.acceleration * delta)
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if not player.is_on_floor():
		player.coyote_jump_timer.start()
	
	if player.scale.y != 1:
		if not is_equal_approx(input_direction_x, 0.0) and Input.is_action_pressed(player.move_left_action):
			player.scale.x = player.scale.y * 1
	if player.scale.y == 1:
		if not is_equal_approx(input_direction_x, 0.0) and Input.is_action_pressed(player.move_right_action):
			player.scale.x = player.scale.y * -1
	
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed(player.jump_action):
		finished.emit(JUMPING)
	elif Input.is_action_just_pressed(player.attack_action):
		finished.emit(ATTACKING)
	elif Input.is_action_just_pressed(player.rope_action):
		finished.emit(ROPE_CASTING)
	elif Input.is_action_just_pressed(player.flare_action) and player.can_flare:
		finished.emit(FLARING)
	elif is_equal_approx(input_direction_x, 0.0):
		finished.emit(IDLE)


func handle_input(_event: InputEvent) -> void:
	if _event.is_action_pressed(player.move_down_action):
		player.set_collision_mask_value(6, false) # Disable cloud mask
		if not player.drop_through_timer.is_stopped():
			player.drop_through_timer.stop()
		player.drop_through_timer.start()
