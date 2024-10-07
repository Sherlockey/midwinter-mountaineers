extends StaticBody2D

@export var speed : float = 150.0

var is_falling : bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shake_animation_player: AnimationPlayer = $ShakeAnimationPlayer
@onready var grow_timer: Timer = $GrowTimer
@onready var formed_timer: Timer = $FormedTimer
@onready var shake_timer: Timer = $ShakeTimer
@onready var fall_timer: Timer = $FallTimer


func _ready() -> void:
	animation_player.play("forming")
	grow_timer.start()


func _physics_process(delta: float) -> void:
	if is_falling:
		position.y += speed * delta


func _on_grow_timer_timeout() -> void:
	animation_player.play("formed")
	formed_timer.start()


func _on_formed_timer_timeout() -> void:
	shake_timer.start()


func _on_shake_timer_timeout() -> void:
	shake_animation_player.play("shake")
	fall_timer.start()

func _on_fall_timer_timeout() -> void:
	shake_animation_player.play("RESET")
	is_falling = true
