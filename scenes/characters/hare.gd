extends CharacterBody2D

enum HareState { IDLE, RUN, HURT, CROUCH }
enum Direction { LEFT = -1, RIGHT = 1 }

@export var initial_direction : Direction = Direction.LEFT
@export var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

var state : HareState
var speed : float = 60.0
var direction : Direction = Direction.LEFT

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var shape_cast_bottom_left: ShapeCast2D = $ShapeCastBottomLeft
@onready var shape_cast_bottom_right: ShapeCast2D = $ShapeCastBottomRight
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hurt_flip_timer: Timer = $HurtFlipTimer
@onready var wait_timer: Timer = $WaitTimer
@onready var crouch_timer: Timer = $CrouchTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_box_collision_shape: CollisionShape2D = $HitBox/HitBoxCollisionShape


func _ready() -> void:
	direction = initial_direction
	if direction == Direction.RIGHT:
		sprite_2d.flip_h = !sprite_2d.flip_h
	wait_timer.start()
	await wait_timer.timeout
	set_state(HareState.RUN)


func _physics_process(delta: float) -> void:
	match state:
		HareState.IDLE:
			return
		HareState.RUN:
			run(delta)
		HareState.HURT:
			hurt(delta)
		HareState.CROUCH:
			crouch(delta)


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage()


func _on_hurt_flip_timer_timeout() -> void:
	if state == HareState.HURT:
		sprite_2d.flip_h = !sprite_2d.flip_h
		hurt_flip_timer.start()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	set_state(HareState.IDLE)
	turn_around()
	wait_timer.start()
	await wait_timer.timeout
	set_state(HareState.RUN)
	hit_box_collision_shape.set_deferred("disabled", false)


func _on_ice_block_failed_respawn() -> void:
	turn_around()
	set_state(HareState.RUN)


func take_damage() -> void:
	if state != HareState.HURT:
		set_state(HareState.HURT)
		hurt_flip_timer.start()
		direction = -initial_direction as Direction
		hit_box_collision_shape.set_deferred("disabled", true)


func run(delta : float) -> void:
	if ray_cast_left.is_colliding():
		turn_around()
	if ray_cast_right.is_colliding():
		turn_around()
	
	check_bottom_rays()
	
	velocity.x = direction * speed
	velocity.y += gravity * delta
	move_and_slide()
	
	if not is_on_floor():
		take_damage()


func hurt(delta : float) -> void:
	if not is_on_floor:
		velocity.x = 0.0
	else:
		velocity.x = direction * speed
	velocity.y += gravity * delta
	move_and_slide()


func crouch(delta : float) -> void:
	velocity.x = 0.0
	velocity.y += gravity * delta
	move_and_slide()
	
	if not is_on_floor():
		take_damage()


func turn_around() -> void:
	direction = -direction as Direction
	sprite_2d.flip_h = direction == 1


func set_state(new_state: HareState) -> void:
	state = new_state
	# TODO fix below, it is not safe. make a dictionary with states and their appropriate animations
	var new_state_string : String = HareState.keys()[new_state].to_lower()
	animation_player.play(new_state_string)


func check_bottom_rays() -> void:
	if direction == Direction.LEFT:
		if shape_cast_bottom_left.is_colliding():
			var collision_object : Object = shape_cast_bottom_left.get_collider(0)
			if collision_object.owner is IceBlock:
				var ice_block: IceBlock = collision_object.owner
				start_respawning_ice_block(ice_block)
		else:
			turn_around()
	elif direction == Direction.RIGHT:
		if shape_cast_bottom_right.is_colliding():
			var collision_object : Object = shape_cast_bottom_right.get_collider(0)
			if collision_object.owner is IceBlock:
				var ice_block: IceBlock = collision_object.owner
				start_respawning_ice_block(ice_block)
		else:
			turn_around()


func start_respawning_ice_block(ice_block : IceBlock) -> void:
	ice_block.failed_respawn.connect(_on_ice_block_failed_respawn)
	set_state(HareState.CROUCH)
	crouch_timer.start()
	await crouch_timer.timeout
	if state == HareState.CROUCH:
		ice_block.respawn()
		ice_block.failed_respawn.disconnect(_on_ice_block_failed_respawn)
		 # Create a short timer because the ice_block is setting its physics bodies deferred, but also it looks better to wait a moment
		await get_tree().create_timer(0.25).timeout
		if state == HareState.CROUCH:
			set_state(HareState.RUN)
