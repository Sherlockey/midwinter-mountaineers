class_name IceBlock
extends StaticBody2D

var is_disabled : bool = false
var has_icicle : bool = false

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func destroy() -> void:
	is_disabled = true
	sprite_2d.visible = false
	collision_shape_2d.set_deferred("disabled", true)
	
	# Handle Icicle child
	if has_icicle:
		has_icicle = false
		for icicle in get_children():
			if icicle is Icicle:
				if icicle.is_formed:
					icicle.drop_early()
				else:
					icicle.destroy()


func _on_icicle_dropped() -> void:
	has_icicle = false
