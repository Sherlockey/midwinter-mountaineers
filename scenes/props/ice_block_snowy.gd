class_name IceBlockSnowy
extends IceBlock

@onready var snow_collision_shape: CollisionShape2D = $SnowArea/SnowCollisionShape


func destroy(new_linear_velocity_x_scalar : float = randi_range(-1, 1)) -> void:
	super(new_linear_velocity_x_scalar)
	snow_collision_shape.set_deferred("disabled", true)


func respawn() -> void:
	super()
	snow_collision_shape.set_deferred("disabled", false)
