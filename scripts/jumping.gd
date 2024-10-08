extends PlayerState

var can_destroy_block : bool = true

@onready var head_marker_2d: Marker2D = $"../../HeadMarker2D"


func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("jump")
	if data:
		if data.get("jump") == false:
			return
	player.velocity.y = -player.jump_impulse


func physics_update(delta: float) -> void:
	# Handle movement
	var input_direction_x := Input.get_axis("move_left", "move_right")
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	# Handle ice_block collisions
	if can_destroy_block:
		var block : IceBlock = null
		var distance : float = INF
		for i in player.get_slide_collision_count():
			var collider := player.get_slide_collision(i).get_collider()
			# TODO figure out why is_in_group() isnt working here
			# maybe because collider is an object and not a node?
			if collider.has_method("destroy"):
				var pos := player.get_slide_collision(i).get_position()
				if pos.y < head_marker_2d.global_position.y:
					var dis : float = pos.distance_to(head_marker_2d.global_position)
					if dis < distance:
						distance = dis
						block = collider
		if block:
			block.destroy()
			can_destroy_block = false
			set_deferred("can_destroy_block", true)
	
	# Handle sprite flipping
	if Input.is_action_pressed("move_left"):
		player.scale.x = player.scale.y * 1
	if Input.is_action_pressed("move_right"):
		player.scale.x = player.scale.y * -1
	
	# Handle exit conditions
	if player.velocity.y >= 0:
		finished.emit(FALLING)
	if Input.is_action_pressed("rope"):
		finished.emit(ROPE_CASTING)
	if Input.is_action_pressed("flare") and player.can_flare:
		finished.emit(FLARING)
	if Input.is_action_pressed("latch") and player.can_latch:
		finished.emit(LATCHING)


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_down"):
		player.set_collision_mask_value(6, false) # Disable cloud mask
		if not player.drop_through_timer.is_stopped():
			player.drop_through_timer.stop()
		player.drop_through_timer.start()
