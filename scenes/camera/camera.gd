class_name Camera
extends Camera2D

const ACCELERATION : float = 10.0

@export var players : Array[Player]


func _ready() -> void:
	global_position.y = players[0].global_position.y


func _physics_process(delta: float) -> void:
	var highest_player : Player = null
	var highest_point : float = INF
	for player in players:
		if player.global_position.y <= highest_point:
			highest_player = player
			highest_point = player.global_position.y
	
	global_position.y = lerp(global_position.y, highest_player.global_position.y, ACCELERATION * delta)
