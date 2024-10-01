extends PlayerState

@onready var attack_area: Area2D = $"../../AttackArea"


func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("attack")
	await player.animation_player.animation_finished
	finished.emit(IDLE)

func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if Input.is_action_pressed("move_left"):
		player.scale.x = player.scale.y * 1
	if Input.is_action_pressed("move_right"):
		player.scale.x = player.scale.y * -1

	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		finished.emit(RUNNING)
	elif Input.is_action_just_pressed("jump"):
		finished.emit(JUMPING)
	elif Input.is_action_just_pressed("flare"):
		finished.emit(FLARING)
	elif Input.is_action_just_pressed("rope"):
		finished.emit(ROPE_CASTING)


func exit() -> void:
	attack_area.monitoring = false


func enable_attack_area_monitoring() -> void:
	attack_area.monitoring = true


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage()
