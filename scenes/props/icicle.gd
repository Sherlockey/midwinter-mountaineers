class_name Icicle
extends Area2D

signal dropped()

@export var speed : float = 150.0

var is_falling : bool = false
var is_formed : bool = false
var can_deal_damage : bool = false
var ice_block_parent : IceBlock

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
	is_formed = true
	can_deal_damage = true


func _on_formed_timer_timeout() -> void:
	shake_timer.start()


func _on_shake_timer_timeout() -> void:
	shake_animation_player.play("shake")
	fall_timer.start()

func _on_fall_timer_timeout() -> void:
	drop()


func check_overlapping_bodies_for_damage() -> void:
	var overlapping_bodies := get_overlapping_bodies()
	for body in overlapping_bodies:
		if body is Player:
			deal_damage(body)


func _on_body_entered(body: Node2D) -> void:
	deal_damage(body)


func deal_damage(body: PhysicsBody2D) -> void:
	if body is Player and can_deal_damage:
		can_deal_damage = false
		body.take_damage()
		destroy()


func destroy() -> void:
	if ice_block_parent:
		if dropped.is_connected(ice_block_parent._on_icicle_dropped):
			dropped.disconnect(ice_block_parent._on_icicle_dropped)
	queue_free()


func drop_early() -> void:
	grow_timer.stop()
	formed_timer.stop()
	shake_timer.stop()
	fall_timer.stop()
	drop()


func drop() -> void:
	shake_animation_player.play("RESET")
	is_falling = true
	can_deal_damage = true
	check_overlapping_bodies_for_damage()
	dropped.emit()
