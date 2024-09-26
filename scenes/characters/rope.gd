class_name Rope
extends Area2D

signal connected(duration : float, speed : float)

const PULL_SPEED : float = 240.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func cast() -> void:
	animation_player.play("cast")
	await animation_player.animation_finished
	if animation_player.is_playing() == false:
		animation_player.play("pull")


func _on_body_entered(body: Node2D) -> void:
	print("hi " + str(body))
	if animation_player.is_playing():
		var interrupted_animation_time : float = animation_player.current_animation_position
		print(interrupted_animation_time)
		animation_player.play("pull")
		animation_player.call_deferred("seek", interrupted_animation_time * 3.0)
		var duration : float = animation_player.current_animation_length - animation_player.current_animation_position
		connected.emit(duration, PULL_SPEED)
	
