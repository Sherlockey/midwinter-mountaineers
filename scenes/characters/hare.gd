extends CharacterBody2D

enum HareState { IDLE, RUN, HURT, CROUCH }
enum Direction { LEFT = -1, RIGHT = 1 }

@export var initial_direction : Direction = Direction.LEFT
@export var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var reset_marker : Marker2D

var state : HareState
var speed : float = 60.0
var direction : Direction = Direction.LEFT

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var shape_cast_bottom_left: ShapeCast2D = $ShapeCastBottomLeft
@onready var shape_cast_bottom_right: ShapeCast2D = $ShapeCastBottomRight
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hurt_flip_timer: Timer = $HurtFlipTimer
@onready var respawn_timer: Timer = $RespawnTimer
@onready var crouch_timer: Timer = $CrouchTimer
@onready var damaged_timer: Timer = $DamagedTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_box_collision_shape: CollisionShape2D = $HitBox/HitBoxCollisionShape
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var reset_position : Vector2 = position


func _ready() -> void:
	await get_tree().create_timer(0.25).timeout
	direction = initial_direction
	sprite_2d.flip_h = direction == Direction.RIGHT
	if reset_marker:
		reset_position = reset_marker.position


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
	if state == HareState.HURT:
		position = reset_position
		direction = initial_direction
		sprite_2d.flip_h = direction == Direction.RIGHT
		hit_box_collision_shape.set_deferred("disabled", true)
		set_state(HareState.IDLE)
		respawn_timer.start()
		await respawn_timer.timeout
		reset()
	else:
		turn_around()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if respawn_timer.is_stopped():
		set_state(HareState.RUN)
	else:
		await respawn_timer.timeout
		set_state(HareState.RUN)


func _on_damaged_timer_timeout() -> void:
	if visible_on_screen_notifier_2d.is_on_screen():
		reset()


func _on_ice_block_failed_respawn() -> void:
	turn_around()
	set_state(HareState.RUN)


func take_damage() -> void:
	if state != HareState.HURT:
		set_state(HareState.HURT)
		damaged_timer.start()
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
	sprite_2d.flip_h = direction == Direction.RIGHT


func reset() -> void:
	set_state(HareState.RUN)
	hit_box_collision_shape.set_deferred("disabled", false)


func set_state(new_state: HareState) -> void:
	state = new_state
	var new_state_string : String = HareState.keys()[new_state].to_lower()
	if animation_player.has_animation(new_state_string):
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
	if not ice_block.failed_respawn.is_connected(_on_ice_block_failed_respawn):
		ice_block.failed_respawn.connect(_on_ice_block_failed_respawn)
	set_state(HareState.CROUCH)
	crouch_timer.start()
	await crouch_timer.timeout
	if state == HareState.CROUCH:
		ice_block.respawn()
		if ice_block.failed_respawn.is_connected(_on_ice_block_failed_respawn):
			ice_block.failed_respawn.disconnect(_on_ice_block_failed_respawn)
		 # Create a short timer because the ice_block is setting its physics bodies deferred, but also it looks better to wait a moment
		await get_tree().create_timer(0.25).timeout
		if state == HareState.CROUCH:
			set_state(HareState.RUN)
