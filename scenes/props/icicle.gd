extends Area2D

@export var speed : float = 150.0

var is_falling : bool = false
var can_damage : bool = false

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
	can_damage = true
	check_overlapping_bodies_for_damage()


func check_overlapping_bodies_for_damage() -> void:
	var overlapping_bodies := get_overlapping_bodies()
	for body in overlapping_bodies:
		if body is Player:
			deal_damage(body)


func _on_body_entered(body: Node2D) -> void:
	deal_damage(body)


func deal_damage(body: PhysicsBody2D) -> void:
	if body is Player and can_damage:
		can_damage = false
		body.take_damage()
		queue_free()


func destroy() -> void:
	queue_free()
