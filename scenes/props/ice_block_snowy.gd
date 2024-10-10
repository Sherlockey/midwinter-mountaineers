class_name IceBlockSnowy
extends IceBlock

@onready var snow_collision_shape: CollisionShape2D = $SnowArea/SnowCollisionShape


func destroy(new_linear_velocity_x_scalar : float) -> void:
	super(new_linear_velocity_x_scalar)
	print('hi')
	snow_collision_shape.set_deferred("disabled", true)
