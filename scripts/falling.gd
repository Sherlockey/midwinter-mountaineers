extends PlayerState


func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("fall")

func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
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
	if player.is_on_floor():
		player.can_latch = true
		if is_equal_approx(input_direction_x, 0.0):
			finished.emit(IDLE)
		else:
			finished.emit(RUNNING)
