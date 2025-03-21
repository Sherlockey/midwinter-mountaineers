extends PlayerState

var is_latched: bool = false
var jump_impulse_scalar : float = 0.875

func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("latching")
	await player.animation_player.animation_finished
	if player.state_machine.state == self:
		set_is_latched(true)
		player.animation_player.play("latched")


func physics_update(delta: float) -> void:
	if not is_latched:
		player.move_and_slide()
		return
	
	if Input.is_action_just_pressed(player.move_down_action):
		finished.emit(FALLING)
	if Input.is_action_just_pressed(player.jump_action):
		var data := { "jump_impulse_scalar" : jump_impulse_scalar}
		finished.emit(JUMPING, data)


func set_is_latched(value: bool) -> void:
	is_latched = value
	player.can_latch = false
	player.velocity = Vector2.ZERO


func exit() -> void:
	is_latched = false
