extends PlayerState

signal flagged()

var has_started_flag_anim : bool = false
var has_finished_flag_anim :bool = false
var has_emitted_flagged : bool = false

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.x = 0.0


func physics_update(delta: float) -> void:
	player.velocity.x = 0.0
	if not player.is_on_floor():
		player.animation_player.play("fall")
		player.velocity.y += player.gravity * delta * player.gravity_falling_multiplier
		player.move_and_slide()
	elif not has_started_flag_anim:
		has_started_flag_anim = true
		player.animation_player.play("flag")
		await player.animation_player.animation_finished
		has_finished_flag_anim = true
	elif has_finished_flag_anim:
		if not has_emitted_flagged:
			flagged.emit()
			has_emitted_flagged = true
			player.animation_player.play("idle")
