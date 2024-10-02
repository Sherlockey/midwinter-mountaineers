class_name Flare
extends Area2D

@export var speed : float = 300.0
@export var max_range : float = 1500.0

var travelled_distance : float = 0.0
var can_destroy_block : bool = true


func _physics_process(delta: float) -> void:
	var direction := Vector2.UP.rotated(rotation)
	position += direction * speed * delta
	
	travelled_distance += speed * delta
	if travelled_distance > max_range:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	print("flare hit " + str(body))
	if body.has_method("destroy") and can_destroy_block:
		body.destroy()
		can_destroy_block = false
	queue_free()
