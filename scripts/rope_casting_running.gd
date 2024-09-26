extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	pass
	#player.animation_player.play("rope_cast")
	#await player.animation_player.animation_finished
	#player.rope.cast()
	#finished.emit(ROPE_RIDING)

func physics_update(delta: float) -> void:
	finished.emit(IDLE)
	##should this still be here?
	#player.move_and_slide()
#
#
	#if Input.is_action_just_pressed("jump"):
		#finished.emit(JUMPING)
	##should attack be added?
