class_name IceBlockDestroyed
extends RigidBody2D

enum SpriteFrame {
	BLUE_FACING_LEFT = 0,
	BLUE_FACING_RIGHT = 1,
	SLIPPERY_FACING_LEFT = 2,
	SLIPPERY_FACING_RIGT = 3,
}

@export var sprite_facing_left : SpriteFrame
@export var sprite_facing_right : SpriteFrame

var linear_velocity_x_scalar : float = 1.0

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	linear_velocity.x *= linear_velocity_x_scalar
	if linear_velocity_x_scalar >= 0.0:
		sprite_2d.frame = sprite_facing_right
	else:
		sprite_2d.frame = sprite_facing_left


func _physics_process(delta: float) -> void:
	# Handle cases where the IceBlockDestroyed is moving right
	if linear_velocity.x >= 0.0:
		#Handle if it is moving up
		if linear_velocity.y <= 150.0:
			sprite_2d.frame = sprite_facing_left
		#Handle if it is moving down
		else:
			sprite_2d.frame = sprite_facing_right
	# Handle cases where the IceBlockDestroyed is moving left
	else:
		#Handle if it is moving up
		if linear_velocity.y <= 200.0:
			sprite_2d.frame = sprite_facing_right
		#Handle if it is moving down
		else:
			sprite_2d.frame = sprite_facing_left


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
