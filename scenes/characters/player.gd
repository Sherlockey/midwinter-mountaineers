class_name Player
extends CharacterBody2D

@export var speed := 100.0
@export var acceleration := 1000.00
@export var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var jump_impulse := 325.0

var can_latch : bool = true
var can_flare : bool = true

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_animation_player: AnimationPlayer = $AttackAnimationPlayer
@onready var damaged_animation_player: AnimationPlayer = $DamagedAnimationPlayer
@onready var rope: Rope = $Rope
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var state_machine: StateMachine = $StateMachine
@onready var drop_through_timer: Timer = $DropThroughTimer
@onready var screen_size : Vector2 = get_viewport_rect().size
@onready var floor_shape_cast_2d: ShapeCast2D = $FloorShapeCast2D


func _physics_process(delta: float) -> void:
	handle_screen_wrap()
	check_floor_for_ice()


func _on_drop_through_timer_timeout() -> void:
	if not Input.is_action_pressed("move_down"):
		set_collision_mask_value(6, true) # Enable cloud mask
	else:
		drop_through_timer.start()


func handle_screen_wrap() -> void:
	position.x = wrapf(position.x, 0, screen_size.x)


func check_floor_for_ice() -> void:
	if floor_shape_cast_2d.is_colliding():
		acceleration = 100.0
	else:
		acceleration = 1000.0


func take_damage() -> void:
	damaged_animation_player.play("damaged")
