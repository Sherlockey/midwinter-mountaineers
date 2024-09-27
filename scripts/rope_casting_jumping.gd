extends PlayerState


func enter(previous_state_path: String, data := {}) -> void:
	# TODO add jump velocity here like Jumping state
	player.animation_player.play("rope_cast")
	await player.animation_player.animation_finished
	player.rope.cast()
	finished.emit(ROPE_RIDING)


func physics_update(delta: float) -> void:
	#should this still be here?
	player.move_and_slide()
	# TODO add logic for jumping etc here


	if Input.is_action_just_pressed("jump"):
		finished.emit(ROPE_CASTING_JUMPING)
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		finished.emit(ROPE_CASTING_RUNNING)
