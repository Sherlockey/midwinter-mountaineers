extends PlayerState


func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("run")


func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if player.scale.y != 1:
		if not is_equal_approx(input_direction_x, 0.0) and Input.is_action_pressed("move_left"):
			player.scale.x = player.scale.y * 1
	if player.scale.y == 1:
		if not is_equal_approx(input_direction_x, 0.0) and Input.is_action_pressed("move_right"):
			player.scale.x = player.scale.y * -1
	
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("jump"):
		finished.emit(JUMPING)
	elif Input.is_action_just_pressed("attack"):
		finished.emit(ATTACKING)
	elif Input.is_action_just_pressed("rope"):
		finished.emit(ROPE_CASTING)
	elif Input.is_action_just_pressed("flare") and player.can_flare:
		finished.emit(FLARING)
	elif is_equal_approx(input_direction_x, 0.0):
		finished.emit(IDLE)


func handle_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("move_down"):
		player.set_collision_mask_value(6, false) # Disable cloud mask
		if not player.drop_through_timer.is_stopped():
			player.drop_through_timer.stop()
		player.drop_through_timer.start()
