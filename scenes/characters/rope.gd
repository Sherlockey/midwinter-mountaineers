class_name Rope
extends Marker2D

signal connected(duration : float)
signal finished()

var collided : bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D


func cast() -> void:
	animation_player.play("cast")
	await animation_player.animation_finished
	if collided == false:
		animation_player.play("pull")
		await animation_player.animation_finished
		finished.emit()


func _physics_process(delta: float) -> void:
	if shape_cast_2d.is_colliding():
		collided = true
		if animation_player.is_playing():
			var interrupted_animation_time : float = animation_player.current_animation_position
			animation_player.play("pull")
			animation_player.seek(0.3 - interrupted_animation_time * 3.0)
			var duration : float = animation_player.current_animation_length - animation_player.current_animation_position
			connected.emit(duration)
			await animation_player.animation_finished
			collided = false
			finished.emit()
