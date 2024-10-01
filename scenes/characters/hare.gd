extends CharacterBody2D

enum Hare_State { IDLE, RUN, HURT }

const SPEED : float = 60

@export var direction : int = -1

var state : Hare_State
var initialized_direction : int

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hurt_flip_timer: Timer = $HurtFlipTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var wait_timer: Timer = $WaitTimer


func _ready() -> void:
	initialized_direction = direction
	wait_timer.start()
	await wait_timer.timeout
	_set_state(Hare_State.RUN)


func _physics_process(delta: float) -> void:
	if state == Hare_State.IDLE:
		return
	
	if ray_cast_right.is_colliding():
		direction = -1
		sprite_2d.flip_h = false
	if ray_cast_left.is_colliding():
		direction = 1
		sprite_2d.flip_h = true
	
	position.x += direction * SPEED * delta


func take_damage() -> void:
	if state != Hare_State.HURT:
		_set_state(Hare_State.HURT)
		hurt_flip_timer.start()
		# TODO change this to be the direction away from the hitter
		direction = -direction


func _set_state(new_state: Hare_State) -> void:
	state = new_state
	# TODO fix below, it is not safe at all
	var new_state_string : String = Hare_State.keys()[new_state].to_lower()
	animation_player.play(new_state_string)


func _on_hurt_flip_timer_timeout() -> void:
	if state == Hare_State.HURT:
		sprite_2d.flip_h = !sprite_2d.flip_h
		hurt_flip_timer.start()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	_set_state(Hare_State.IDLE)
	direction = initialized_direction
	sprite_2d.flip_h = direction == 1
	wait_timer.start()
	await wait_timer.timeout
	_set_state(Hare_State.RUN)
