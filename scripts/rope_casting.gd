extends PlayerState


func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("rope_cast")
	await player.animation_player.animation_finished
	player.rope.cast()
	player.rope.connected.connect(_on_rope_collided)
	player.rope.finished.connect(_on_rope_finished)


func physics_update(delta: float) -> void:
	#should this still be here?
	player.move_and_slide()


	if Input.is_action_just_pressed("jump"):
		exit()
		finished.emit(ROPE_CASTING_JUMPING)
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		exit()
		finished.emit(ROPE_CASTING_RUNNING)


func _on_rope_collided(duration : float) -> void:
	var data = { "duration" : duration}
	exit()
	finished.emit(ROPE_RIDING, data)


func _on_rope_finished() -> void:
	if player.is_on_floor():
		exit()
		finished.emit(IDLE)
	else:
		exit()
		finished.emit(FALLING)


func exit() -> void:
	if player.rope.connected.is_connected(_on_rope_collided):
		player.rope.connected.disconnect(_on_rope_collided)
	if player.rope.finished.is_connected(_on_rope_finished):
		player.rope.finished.disconnect(_on_rope_finished)
