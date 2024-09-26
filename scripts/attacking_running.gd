extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	pass
	#player.animation_player.play("attack")
	#await player.animation_player.animation_finished
	#finished.emit(IDLE)

func physics_update(delta: float) -> void:
	finished.emit(IDLE)
	#var input_direction_x := Input.get_axis("move_left", "move_right")
	#player.velocity.x = player.speed * input_direction_x
	#player.velocity.y += player.gravity * delta
	#player.move_and_slide()
	#
	#if Input.is_action_pressed("move_left"):
		#player.sprite_2d.flip_h = false
	#if Input.is_action_pressed("move_right"):
		#player.sprite_2d.flip_h = true
#
	#if not player.is_on_floor():
		#finished.emit(FALLING)
	#elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		#finished.emit(RUNNING)
	#elif Input.is_action_just_pressed("jump"):
		#finished.emit(JUMPING)
	#elif Input.is_action_just_pressed("jump"):
		#finished.emit(JUMPING)
	#elif Input.is_action_just_pressed("flare"):
		#finished.emit(FLARING_RUNNING)
	#elif Input.is_action_just_pressed("rope"):
		#finished.emit(ROPE_CASTING_RUNNING)
