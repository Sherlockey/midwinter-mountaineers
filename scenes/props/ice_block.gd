class_name IceBlock
extends StaticBody2D

signal failed_respawn()

@export var ice_block_destroyed_scene : PackedScene

var is_disabled : bool = false
var has_icicle : bool = false

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var residual_collision_shape: CollisionShape2D = $ResidualArea/ResidualCollisionShape
@onready var residual_area: Area2D = $ResidualArea


func destroy(new_linear_velocity_x_scalar : float = randi_range(-1, 1)) -> void:
	is_disabled = true
	sprite_2d.visible = false
	collision_shape_2d.set_deferred("disabled", true)
	residual_collision_shape.set_deferred("disabled", false)
	
	# Handle Icicle child
	if has_icicle:
		has_icicle = false
		for icicle in get_children():
			if icicle is Icicle:
				if icicle.is_formed:
					icicle.drop_early()
				else:
					icicle.destroy()
	
	# Create IceBlockDestroyed
	var ice_block_destroyed : IceBlockDestroyed = ice_block_destroyed_scene.instantiate()
	ice_block_destroyed.linear_velocity_x_scalar = new_linear_velocity_x_scalar
	add_child(ice_block_destroyed)
	ice_block_destroyed.global_position = global_position


func respawn() -> void:
	for body in residual_area.get_overlapping_bodies():
		if body is Player:
			failed_respawn.emit()
			return
	is_disabled = false
	sprite_2d.visible = true
	collision_shape_2d.set_deferred("disabled", false)
	residual_collision_shape.set_deferred("disabled", true)


func _on_icicle_dropped() -> void:
	has_icicle = false
