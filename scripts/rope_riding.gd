extends PlayerState

const PULL_SPEED : float = 240.0

var direction_scalar : int = 1


func enter(previous_state_path: String, data := {}) -> void:
	direction_scalar = data.get("direction_scalar")
	player.animation_player.play("rope_ride")
	await get_tree().create_timer(data.get("duration")).timeout
	finished.emit(FALLING)


func physics_update(delta: float) -> void:
	player.velocity.x = PULL_SPEED * direction_scalar
	player.velocity.y = 0.0
	player.move_and_slide()
	
	if Input.is_action_just_pressed("jump"):
		finished.emit(JUMPING)
