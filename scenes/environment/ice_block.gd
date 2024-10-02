class_name IceBlock
extends StaticBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func destroy() -> void:
	sprite_2d.visible = false
	collision_shape_2d.set_deferred("disabled", true)
