extends Area2D

@export var point_value : float = 100


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	print(point_value)
	queue_free()
