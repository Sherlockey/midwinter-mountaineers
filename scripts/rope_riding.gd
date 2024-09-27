extends PlayerState

const PULL_SPEED : float = 240.0


func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("rope_ride")
	await get_tree().create_timer(data.get("duration")).timeout
	finished.emit(FALLING)


func physics_update(delta: float) -> void:
	player.velocity.x = -PULL_SPEED
	player.velocity.y = 0.0
	player.move_and_slide()
	
	if Input.is_action_just_pressed("jump"):
		finished.emit(JUMPING)
