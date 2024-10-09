extends Node2D

@onready var snow: Snow = $Snow
@onready var player: Player = $Player


func _ready() -> void:
	snow.wind_changed.connect(player._on_snow_wind_changed)


func _on_flag_reached() -> void:
	print("You win!")
