extends PlayerState


func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("rope_cast")
	await player.animation_player.animation_finished
	if player.state_machine.state == self:
		player.rope.cast()
	
	if not player.rope.connected.is_connected(_on_rope_collided):
		player.rope.connected.connect(_on_rope_collided)
	if not player.rope.finished.is_connected(_on_rope_finished):
		player.rope.finished.connect(_on_rope_finished)


func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis(player.move_left_action, player.move_right_action)
	player.velocity.x = move_toward(player.velocity.x, player.speed * input_direction_x + player.wind_push, player.acceleration * delta)
	
	if player.is_full_hop:
		player.velocity.y += player.gravity * delta
	else:
		player.velocity.y += player.gravity * delta * player.short_hop_multiplier
	
	player.move_and_slide()
	
	if not player.is_on_floor():
		player.coyote_jump_timer.start()
	
	if Input.is_action_pressed(player.move_left_action) and player.scale.y == -1:
		player.rope.cancel_cast()
	elif Input.is_action_just_pressed(player.move_right_action) and player.scale.y == 1:
		player.rope.cancel_cast()
	elif Input.is_action_just_pressed(player.jump_action):
		player.velocity.y = -player.jump_impulse
		player.is_full_hop = true
		player.full_hop_timer.start()
	elif Input.is_action_just_pressed(player.attack_action):
		player.rope.cancel_cast()
		finished.emit(ATTACKING)


func _on_rope_collided(duration : float, direction_scalar : int) -> void:
	var data := { "duration" : duration, "direction_scalar" : direction_scalar}
	finished.emit(ROPE_RIDING, data)


func _on_rope_finished() -> void:
	if player.is_on_floor():
		if Input.is_action_just_pressed(player.attack_action):
			finished.emit(ATTACKING)
		else:
			finished.emit(IDLE)
	else:
		if player.velocity.y > 0:
			finished.emit(FALLING)
		else:
			var data := { "jump": false }
			finished.emit(JUMPING, data)


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed(player.move_down_action):
		player.set_collision_mask_value(6, false) # Disable cloud mask
		if not player.drop_through_timer.is_stopped():
			player.drop_through_timer.stop()
		player.drop_through_timer.start()


func exit() -> void:
	if player.rope.connected.is_connected(_on_rope_collided):
		player.rope.connected.disconnect(_on_rope_collided)
	if player.rope.finished.is_connected(_on_rope_finished):
		player.rope.finished.disconnect(_on_rope_finished)
