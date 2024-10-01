extends PlayerState

@onready var attack_area: Area2D = $"../../AttackArea"


func enter(previous_state_path: String, data := {}) -> void:
	if is_equal_approx(player.velocity.x, 0.0):
		player.animation_player.play("attack")
	else:
		player.animation_player.play("attack_running")
	player.attack_animation_player.play("attack_vfx")
	await player.animation_player.animation_finished
	if player.state_machine.state == self:
		if is_equal_approx(player.velocity.x, 0.0):
			finished.emit(IDLE)
		else:
			finished.emit(RUNNING)


func physics_update(delta: float) -> void:
	# Handle movement
	var input_direction_x := Input.get_axis("move_left", "move_right")
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	# Handle object flipping
	if Input.is_action_pressed("move_left"):
		player.scale.x = player.scale.y * 1
	if Input.is_action_pressed("move_right"):
		player.scale.x = player.scale.y * -1
	
	# Handle animations
	if is_equal_approx(input_direction_x, 0):
		if player.animation_player.current_animation == "attack_running":
			var interrupted_animation_time : float = player.animation_player.current_animation_position
			player.animation_player.play("attack")
			player.animation_player.seek(interrupted_animation_time)
	else:
		if player.animation_player.current_animation == "attack":
			var interrupted_animation_time : float = player.animation_player.current_animation_position
			player.animation_player.play("attack_running")
			player.animation_player.seek(interrupted_animation_time)
	
	# Handle exit conditions
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("jump"):
		player.attack_animation_player.play("RESET")
		finished.emit(JUMPING)
	elif Input.is_action_just_pressed("flare"):
		finished.emit(FLARING)
	elif Input.is_action_just_pressed("rope"):
		finished.emit(ROPE_CASTING)


func exit() -> void:
	attack_area.monitoring = false
	player.speed = 100.0


func enable_attack_area_monitoring() -> void:
	attack_area.monitoring = true


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage()
