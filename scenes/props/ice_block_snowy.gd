class_name IceBlockSnowy
extends IceBlock

@onready var snow_collision_shape: CollisionShape2D = $SnowArea/SnowCollisionShape


func destroy() -> void:
	sprite_2d.visible = false
	collision_shape_2d.set_deferred("disabled", true)
	snow_collision_shape.set_deferred("disabled", true)
