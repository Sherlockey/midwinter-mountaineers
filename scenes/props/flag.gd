extends Area2D

signal reached()

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _on_body_entered(body: Node2D) -> void:
	animation_player.play("wave")
	reached.emit()
	collision_shape_2d.set_deferred("disabled", true)
