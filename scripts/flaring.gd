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
	var input_direction_x := Input.get_axis("move_left", "move_right")
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	
	player.move_and_slide()


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_down"):
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
