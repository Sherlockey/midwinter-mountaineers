extends Node2D

@onready var snow: Snow = $Snow
@onready var player: Player = $Player
@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var icicle_spawner: IcicleSpawner


func _ready() -> void:
	snow.wind_changed.connect(player._on_snow_wind_changed)


func _on_flag_reached() -> void:
	print("You win!")
