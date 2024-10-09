class_name Snow
extends Node2D

signal wind_changed(wind_push : float)

const SNOWFALL : String = "snowfall"
const WIND_BLOWING_LEFT : String = "wind_blowing_left"
const WIND_BLOWING_RIGHT : String = "wind_blowing_right"

@export var wind_push : float = 37.5

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
	play_animation_at_same_time_as_current(WIND_BLOWING_LEFT)
	wind_changed.emit(-wind_push)
	await get_tree().create_timer(3.0).timeout
	play_animation_at_same_time_as_current(WIND_BLOWING_RIGHT)
	wind_changed.emit(wind_push)
	await get_tree().create_timer(3.0).timeout
	play_animation_at_same_time_as_current(SNOWFALL)
	wind_changed.emit(0.0)


func play_animation_at_same_time_as_current(animation_name : String) -> void:
	var start_time : float = 0.0
	var time_scalar : float = 1.0
	var old_animation_name : String = animation_player.current_animation
	if old_animation_name == SNOWFALL:
		if animation_name == WIND_BLOWING_LEFT or animation_name == WIND_BLOWING_RIGHT:
			time_scalar = 0.333333
	elif old_animation_name == WIND_BLOWING_LEFT or old_animation_name == WIND_BLOWING_RIGHT:
		if animation_name == SNOWFALL:
			time_scalar = 3.0
	if animation_player.is_playing():
		start_time = animation_player.current_animation_position
	animation_player.play(animation_name)
	animation_player.seek(start_time * time_scalar)
