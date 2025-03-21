class_name Player
extends CharacterBody2D

signal screen_exited(player: Player)
signal fruit_collected(value: int)

@export var speed := speed_base
@export var acceleration := acceleration_base
@export var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var gravity_falling_multiplier : float = 1.5
@export var short_hop_multiplier : float = 2.5
@export var jump_impulse := jump_impulse_base
@export var is_vulnerable : bool = true
@export var player_2_texture : Texture2D

var move_up_action := "move_up"
var move_down_action := "move_down"
var move_left_action := "move_left"
var move_right_action := "move_right"
var jump_action := "jump"
var attack_action := "attack"
var rope_action := "rope"
var flare_action := "flare"
var latch_action := "latch"
var menu_action := "menu"
var is_full_hop : bool = false
var is_in_snow : bool = false
var can_latch : bool = true
var can_flare : bool = true
var speed_base : float = 100.0
var speed_slowed : float = 50.0
var acceleration_base : float = 1000.0
var acceleration_slippery : float = 100.0
var jump_impulse_base: float = 330.0
var jump_impulse_slowed : float = 185.714
var damaged_impulse_modifier : float = -1.25
var wind_push : float = 0.0
var player_number : int = 1

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_animation_player: AnimationPlayer = $AttackAnimationPlayer
@onready var damaged_animation_player: AnimationPlayer = $DamagedAnimationPlayer
@onready var rope: Rope = $Rope
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var state_machine: StateMachine = $StateMachine
@onready var drop_through_timer: Timer = $DropThroughTimer
@onready var full_hop_timer: Timer = $FullHopTimer
@onready var coyote_jump_timer: Timer = $CoyoteJumpTimer
@onready var screen_size : Vector2 = get_viewport_rect().size
@onready var ice_floor_shape_cast_2d: ShapeCast2D = $IceFloorShapeCast2D
@onready var snow_floor_shape_cast_2d: ShapeCast2D = $SnowFloorShapeCast2D
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D


func _physics_process(delta: float) -> void:
	handle_screen_wrap()
	check_floor_for_ice()
	check_floor_for_snow()
	handle_slowed()


func _on_drop_through_timer_timeout() -> void:
	if not Input.is_action_pressed(move_down_action):
		set_collision_mask_value(6, true) # Enable cloud mask
	else:
		drop_through_timer.start()


func _on_wind_manager_wind_changed(new_wind_push : float) -> void:
	wind_push = new_wind_push


func take_damage() -> void:
	if is_vulnerable:
		damaged_animation_player.play("damaged")
		# Knock the player up and away from current x velocity. 
		# Could instead take location of damage and move away from that
		velocity.x = damaged_impulse_modifier * velocity.x
		velocity.y = -jump_impulse_slowed


func respawn(respawn_position: Vector2) -> void:
	state_machine.state.finished.emit(PlayerState.FALLING)
	velocity = Vector2.ZERO
	global_position = respawn_position
	damaged_animation_player.play("damaged")
	state_machine.state.finished.emit(PlayerState.FALLING)


func handle_screen_wrap() -> void:
	position.x = wrapf(position.x, 0, screen_size.x)


func check_floor_for_ice() -> void:
	if ice_floor_shape_cast_2d.is_colliding():
		acceleration = acceleration_slippery
	else:
		acceleration = acceleration_base


func check_floor_for_snow() -> void:
	if snow_floor_shape_cast_2d.is_colliding():
		is_in_snow = true
	else:
		is_in_snow = false


func handle_slowed() -> void:
	if is_in_snow or not is_vulnerable:
		speed = speed_slowed
		jump_impulse = jump_impulse_slowed
	else:
		speed = speed_base
		jump_impulse = jump_impulse_base


func _on_full_hop_timer_timeout() -> void:
	if Input.is_action_pressed(jump_action):
		is_full_hop = true
	else:
		is_full_hop = false


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	screen_exited.emit(self)
