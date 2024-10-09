extends Node2D

@export var wind_push : float = 45.0

@onready var snow: Snow = $Snow
@onready var player: Player = $Player


func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
	snow.play_animation_at_same_time_as_current(snow.WIND_BLOWING_LEFT)
	player.wind_push = -wind_push
	await get_tree().create_timer(3.0).timeout
	snow.play_animation_at_same_time_as_current(snow.WIND_BLOWING_RIGHT)
	player.wind_push = wind_push
	await get_tree().create_timer(3.0).timeout
	snow.play_animation_at_same_time_as_current(snow.SNOWFALL)
	player.wind_push = 0.0
