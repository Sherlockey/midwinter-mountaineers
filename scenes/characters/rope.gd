class_name Rope
extends Marker2D

signal connected(duration : float, direction_scalar : int)
signal finished()

var is_casting : bool = false
var is_colliding : bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D


func _physics_process(delta: float) -> void:
	if shape_cast_2d.is_colliding():
		# might not need this if check
		if animation_player.is_playing():
			is_colliding = true
			var interrupted_animation_time : float = animation_player.current_animation_position
			animation_player.play("pull")
			animation_player.seek(0.3 - interrupted_animation_time * 3.0)
			var duration : float = animation_player.current_animation_length - animation_player.current_animation_position
			var direction_scalar : int
			if shape_cast_2d.get_collision_point(0).x <= owner.position.x:
				direction_scalar = -1
			else:
				direction_scalar = 1
			connected.emit(duration, direction_scalar)
			await animation_player.animation_finished
			is_casting = false
			is_colliding = false
			finished.emit()


func cast() -> void:
	if is_casting == true:
		return
	animation_player.play("cast")
	is_casting = true
	
	await animation_player.animation_finished
	if is_colliding == false and is_casting == true:
		animation_player.play("pull")
		await animation_player.animation_finished
		is_casting = false
		finished.emit()


func cancel_cast() -> void:
	is_casting = false
	is_colliding = false
	animation_player.play("RESET")
	finished.emit()
