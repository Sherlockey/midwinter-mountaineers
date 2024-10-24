class_name Eagle
extends CharacterBody2D

enum EagleState { IDLE, RUN, HURT, CHASE }
enum Direction { LEFT = -1, RIGHT = 1 }

const OFFSCREEN_Y_BUFFER : float = 15.0

@export var initial_direction : Direction = Direction.LEFT
@export var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

var player : Player = null
var target : Vector2 = Vector2.ZERO
var state : EagleState
var speed : float = 60.0
var acceleration : float = 25.0
var heading : Vector2
var min_distance : float = 50.0
var max_distance : float = 500.0
var min_change_wait_time : float = 1.5
var max_change_wait_time : float = 2.5
var min_speed : float = 20.0
var max_speed : float = 40.0
var direction : Direction = Direction.LEFT

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var speed_change_timer: Timer = $SpeedChangeTimer
@onready var distance_change_timer: Timer = $DistanceChangeTimer
@onready var wait_timer: Timer = $WaitTimer
@onready var hurt_flip_timer: Timer = $HurtFlipTimer
@onready var offscreen_timer: Timer = $OffscreenTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_box_collision_shape: CollisionShape2D = $HitBox/HitBoxCollisionShape
@onready var hurt_box_collision_shape: CollisionShape2D = $HurtBoxCollisionShape
@onready var helmet_hurt_box_collision_shape: CollisionShape2D = $HelmetHurtBox/HelmetHurtBoxCollisionShape
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _ready() -> void:
	direction = initial_direction
	if direction == Direction.RIGHT:
		sprite_2d.flip_h = !sprite_2d.flip_h
	set_random_target_and_heading()
	set_state(EagleState.RUN)


func _physics_process(delta: float) -> void:
	match state:
		EagleState.IDLE:
			return
		EagleState.RUN:
			run(delta)
		EagleState.HURT:
			hurt(delta)
		EagleState.CHASE:
			chase(delta)


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage()


func _on_speed_change_timer_timeout() -> void:
	speed = randf_range(min_speed, max_speed)
	var speed_change_wait_time : float = randf_range(min_change_wait_time, max_change_wait_time)
	speed_change_timer.wait_time = speed_change_wait_time
	speed_change_timer.start()


func _on_distance_change_timer_timeout() -> void:
	set_random_target_and_heading()
	var distance_change_wait_time : float = randf_range(min_change_wait_time, max_change_wait_time)
	distance_change_timer.wait_time = distance_change_wait_time
	distance_change_timer.start()


func _on_hurt_flip_timer_timeout() -> void:
	if state == EagleState.HURT:
		sprite_2d.flip_h = !sprite_2d.flip_h
		hurt_flip_timer.start()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	#TODO handle situations where the eagle goes offscreen vertically as well as horizontally
	#TODO if it goes offscreen vertically, maybe despawn and spawn a new eagle in the middle of the screen?
	if state == EagleState.HURT:
		queue_free()
		return
	
	hurt_box_collision_shape.set_deferred("disabled", true)
	helmet_hurt_box_collision_shape.set_deferred("disabled", true)
	hit_box_collision_shape.set_deferred("disabled", true)
	
	var screen_center_position : Vector2 = get_viewport().get_camera_2d().get_screen_center_position()
	var top_screen : float = screen_center_position.y - ProjectSettings.get_setting("display/window/size/viewport_height") / 2.0
	var bottom_screen : float = screen_center_position.y + ProjectSettings.get_setting("display/window/size/viewport_height") / 2.0
	
	if abs(top_screen - visible_on_screen_notifier_2d.global_position.y) <= OFFSCREEN_Y_BUFFER or \
	abs(bottom_screen - visible_on_screen_notifier_2d.global_position.y)  <= OFFSCREEN_Y_BUFFER:
		disable_all_timers()
	else:
		set_state(EagleState.IDLE)
		turn_around()
		wait_timer.start()
		await wait_timer.timeout
		set_state(EagleState.RUN)
	
	offscreen_timer.start()


func _on_offscreen_timer_timeout() -> void:
	if not visible_on_screen_notifier_2d.is_on_screen():
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	hurt_box_collision_shape.set_deferred("disabled", false)
	helmet_hurt_box_collision_shape.set_deferred("disabled", false)
	hit_box_collision_shape.set_deferred("disabled", false)
	if not offscreen_timer.is_stopped:
		offscreen_timer.stop()


func take_damage() -> void:
	if state != EagleState.HURT:
		set_state(EagleState.HURT)
		velocity.x = 0.0
		hurt_flip_timer.start()
		hit_box_collision_shape.set_deferred("disabled", true)
		hurt_box_collision_shape.set_deferred("disabled", true)
		helmet_hurt_box_collision_shape.set_deferred("disabled", true)


func run(delta : float) -> void:
	velocity.x = move_toward(velocity.x, direction * heading.x * speed,  acceleration * delta)
	velocity.y = move_toward(velocity.y, heading.y * speed,  acceleration * delta)
	move_and_slide()


func hurt(delta : float) -> void:
	velocity.y += gravity * delta
	move_and_slide()


func chase(delta : float) -> void:
	velocity.x = 0.0
	#velocity.y += gravity * delta
	move_and_slide()


func turn_around() -> void:
	sprite_2d.flip_h = not sprite_2d.flip_h
	
	if direction == Direction.LEFT:
		direction = Direction.RIGHT
	else:
		direction = Direction.LEFT


func set_random_target_and_heading() -> void:
	target.x = randf_range(min_distance, max_distance)
	target.y = randf_range(min_distance, max_distance)
	# If the eagle is near the top or bottom edge of the screen, have it move towards the middle of the screen 75% of the time
	var screen_center_position : Vector2 = get_viewport().get_camera_2d().get_screen_center_position()
	
	# Check if the eagle is above a high threshold of the screen
	if visible_on_screen_notifier_2d.global_position.y <= (screen_center_position.y - 90.0):
		if target.y <= 0.0:
			target.y *= -1
	# Check if the eagle is below a low threshold of the screen
	elif visible_on_screen_notifier_2d.global_position.y >= (screen_center_position.y + 10.0):
		if target.y >= 0.0:
			target.y *= -1
	else:
		var sign_array : Array[int] = [-1, 1]
		var y_sign : int = sign_array.pick_random()
		target.y *= y_sign
	
	heading = target.normalized()


func disable_all_timers() -> void:
	speed_change_timer.stop()
	distance_change_timer.stop()
	wait_timer.stop()
	hurt_flip_timer.stop()


func set_state(new_state: EagleState) -> void:
	state = new_state
	var new_state_string : String = EagleState.keys()[new_state].to_lower()
	if animation_player.has_animation(new_state_string):
		animation_player.play(new_state_string)
	
	match state:
		EagleState.RUN:
			var speed_change_wait_time : float = randf_range(min_change_wait_time, max_change_wait_time)
			speed_change_timer.wait_time = speed_change_wait_time
			speed_change_timer.start()
			
			var distance_change_wait_time : float = randf_range(min_change_wait_time, max_change_wait_time)
			distance_change_timer.wait_time = distance_change_wait_time
			distance_change_timer.start()
