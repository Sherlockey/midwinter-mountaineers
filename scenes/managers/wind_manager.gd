class_name WindManager
extends Node

signal wind_changed(wind_push : float)

@export var wind_push : float = 37.5

var snow_array: Array[Snow] = []

@onready var timer: Timer = $Timer


func _ready() -> void:
	for child in get_children():
		if child is Snow:
			snow_array.append(child)
		elif child is WindTrigger:
			child.wind_triggered.connect(_on_wind_trigger_triggered)


func change_wind(direction: String) -> void:
	for snow in snow_array:
		snow.set_snow_animation(direction)

	if direction == Snow.WIND_BLOWING_LEFT:
		wind_changed.emit(-wind_push)
	if direction == Snow.WIND_BLOWING_RIGHT:
		wind_changed.emit(wind_push)
	if direction == Snow.SNOWFALL:
		wind_changed.emit(0.0)


func _on_wind_trigger_triggered(direction: int, duration: float) -> void:
	match(direction):
		-1:
			change_wind(Snow.WIND_BLOWING_LEFT)
		0:
			change_wind(Snow.SNOWFALL)
		1:
			change_wind(Snow.WIND_BLOWING_RIGHT)
	
	if duration != 0:
		timer.wait_time = duration
		timer.start()


func _on_timer_timeout() -> void:
	change_wind(Snow.SNOWFALL)
