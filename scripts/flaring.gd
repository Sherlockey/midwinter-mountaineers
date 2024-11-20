extends PlayerState

@export var flare_scene : PackedScene
@export var flare_vfx_scene : PackedScene

@onready var flare_spawn_point: Marker2D = $"../../FlareSpawnPoint"
@onready var flare_timer: Timer = $"../../FlareTimer"


func enter(previous_state_path: String, data := {}) -> void:
	# TODO add checks for if running or jumping or falling
	player.animation_player.play("flare")
	await player.animation_player.animation_finished
	if player.state_machine.state == self:
		# TODO add checks for which state to transition to
		finished.emit(IDLE)


func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis(player.move_left_action, player.move_right_action)
	player.velocity.x = move_toward(player.velocity.x, player.speed * input_direction_x + player.wind_push, player.acceleration * delta)
	
	if player.is_full_hop:
		player.velocity.y += player.gravity * delta
	else:
		player.velocity.y += player.gravity * delta * player.short_hop_multiplier
	
	player.move_and_slide()
	
	if not player.is_on_floor():
		player.coyote_jump_timer.start()
	
	if Input.is_action_just_pressed(player.jump_action):
		player.velocity.y = -player.jump_impulse
		player.is_full_hop = true
		player.full_hop_timer.start()


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed(player.move_down_action):
		player.set_collision_mask_value(6, false) # Disable cloud mask
		if not player.drop_through_timer.is_stopped():
			player.drop_through_timer.stop()
		player.drop_through_timer.start()


func cast_flare() -> void:
	player.can_flare = false
	flare_timer.start()
	
	var flare : Node = flare_scene.instantiate()
	flare_spawn_point.add_child(flare)
	flare.global_position = flare_spawn_point.global_position
	
	var flare_vfx : Node = flare_vfx_scene.instantiate()
	flare_spawn_point.add_child(flare_vfx)
	flare_vfx.global_position = flare_spawn_point.global_position


func _on_flare_timer_timeout() -> void:
	player.can_flare = true
