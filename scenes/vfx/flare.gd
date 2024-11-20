class_name Flare
extends Area2D

@export var speed : float = 300.0
@export var max_range : float = 100.0

var travelled_distance : float = 0.0


func _physics_process(delta: float) -> void:
	var direction := Vector2.UP.rotated(rotation)
	position += direction * speed * delta
	
	travelled_distance += speed * delta
	if travelled_distance > max_range:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is CollisionObject2D:
		if body.get_collision_layer_value(12): # Then it is a brick
			queue_free()
			return
	
	if body.has_method("destroy"):
		body.destroy()


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("destroy"):
		area.destroy()
