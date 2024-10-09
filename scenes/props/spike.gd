extends Area2D

var target_player : Player
var player_is_colliding : bool = false


func _physics_process(delta: float) -> void:
	if player_is_colliding:
		for body in get_overlapping_bodies():
			if body is Player:
				deal_damage(target_player)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_is_colliding = true
		target_player = body


func take_damage() -> void:
	queue_free()


func deal_damage(body: PhysicsBody2D) -> void:
	body.take_damage()


func _on_body_exited(body: Node2D) -> void:
	if body is Player and target_player == body:
		player_is_colliding = false
		target_player = null
