class_name WindTrigger
extends Area2D

signal wind_triggered(direction : int, duration : float)

@export_range(-1, 1) var direction: int
@export var duration : float = 0


func _on_body_entered(body: Node2D) -> void:
	wind_triggered.emit(direction, duration)
