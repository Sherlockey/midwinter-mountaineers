extends PlayerState

var can_destroy_block : bool = true

@onready var head_marker_2d: Marker2D = $"../../HeadMarker2D"
@onready var helmet_attack_area: Area2D = $"../../HelmetAttackArea"


func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("jump")
	player.is_full_hop = true
	player.full_hop_timer.start()
	helmet_attack_area.monitoring = true
	if data:
		if data.get("jump") == false:
			return
		if data.get("jump_impulse_scalar"):
			player.velocity.y = -player.jump_impulse * data.get("jump_impulse_scalar")
			return
	player.velocity.y = -player.jump_impulse


func physics_update(delta: float) -> void:
	# Handle movement
	var input_direction_x := Input.get_axis(player.move_left_action, player.move_right_action)
	player.velocity.x = move_toward(player.velocity.x, player.speed * input_direction_x + player.wind_push, player.acceleration * delta)
	
	if player.is_full_hop:
		player.velocity.y += player.gravity * delta
	else:
		player.velocity.y += player.gravity * delta * player.short_hop_multiplier
	
	player.move_and_slide()
	
	handle_ice_block_collisions()
	
	# Handle sprite flipping
	if Input.is_action_pressed(player.move_left_action):
		player.scale.x = player.scale.y * 1
	if Input.is_action_pressed(player.move_right_action):
		player.scale.x = player.scale.y * -1
	
	# Handle exit conditions
	if player.velocity.y >= 0:
		finished.emit(FALLING)
	if Input.is_action_pressed(player.rope_action):
		finished.emit(ROPE_CASTING)
	if Input.is_action_pressed(player.flare_action) and player.can_flare:
		finished.emit(FLARING)
	if Input.is_action_pressed(player.latch_action) and player.can_latch:
		finished.emit(LATCHING)


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed(player.move_down_action):
		player.set_collision_mask_value(6, false) # Disable cloud mask
		if not player.drop_through_timer.is_stopped():
			player.drop_through_timer.stop()
		player.drop_through_timer.start()


func handle_ice_block_collisions() -> void:
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
			block.destroy(-player.scale.y)
			can_destroy_block = false
			set_deferred("can_destroy_block", true)


func exit() -> void:
	helmet_attack_area.monitoring = false


func _on_helmet_attack_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Eagle:
		var eagle : Eagle = area.get_parent()
		eagle.take_damage()
