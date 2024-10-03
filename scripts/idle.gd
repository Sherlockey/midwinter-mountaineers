extends PlayerState


func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.x = 0.0
	player.animation_player.play("idle")

func physics_update(_delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	player.velocity.y += player.gravity * _delta
	player.move_and_slide()

	if not is_equal_approx(input_direction_x, 0.0):
		finished.emit(RUNNING)
	elif not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("jump"):
		finished.emit(JUMPING)
	elif Input.is_action_just_pressed("attack"):
		finished.emit(ATTACKING)
	elif Input.is_action_just_pressed("rope"):
		finished.emit(ROPE_CASTING)
	elif Input.is_action_just_pressed("flare") and player.can_flare:
		finished.emit(FLARING)


func handle_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("move_down"):
		player.set_collision_mask_value(6, false) # Disable cloud mask
		if not player.drop_through_timer.is_stopped():
			player.drop_through_timer.stop()
		player.drop_through_timer.start()
