extends CharacterBody2D

enum State { IDLE, RUN, HURT }

const SPEED : float = 60

var state : State
var direction : int = -1

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hurt_flip_timer: Timer = $HurtFlipTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var wait_timer: Timer = $WaitTimer


func _ready() -> void:
	wait_timer.start()
	await wait_timer.timeout
	_set_state(State.RUN)


func _physics_process(delta: float) -> void:
	if state == State.IDLE:
		return
	
	if ray_cast_right.is_colliding():
		direction = -1
		sprite_2d.flip_h = false
	if ray_cast_left.is_colliding():
		direction = 1
		sprite_2d.flip_h = true
	
	position.x += direction * SPEED * delta


func take_damage() -> void:
	_set_state(State.HURT)
	hurt_flip_timer.start()
	# TODO change this to be the direction away from the hitter
	direction = -direction


func _set_state(new_state: State) -> void:
	state = new_state
	# TODO fix below, it is not safe at all
	var new_state_string : String = State.keys()[new_state].to_lower()
	animation_player.play(new_state_string)


func _on_hurt_flip_timer_timeout() -> void:
	if state == State.HURT:
		sprite_2d.flip_h = !sprite_2d.flip_h
		hurt_flip_timer.start()
