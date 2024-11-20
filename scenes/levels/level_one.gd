class_name LevelOne
extends Node2D

@export var players : Array[Player]
@export var player_scene : PackedScene

var number_of_players : int = 1
var move_up_action2 := "move_up2"
var move_down_action2 := "move_down2"
var move_left_action2 := "move_left2"
var move_right_action2 := "move_right2"
var jump_action2 := "jump2"
var attack_action2 := "attack2"
var rope_action2 := "rope2"
var flare_action2 := "flare2"
var latch_action2 := "latch2"
var menu_action2 := "menu2"

@onready var snow: Snow = $Snow
@onready var tile_map_layer: TileMapLayer = $ForegroundTileMap
@onready var icicle_spawner: IcicleSpawner
@onready var player_2_starting_position: Marker2D = $Player2StartingPosition
@onready var camera: Camera = $Camera


func _ready() -> void:
	assert(player_scene != null, "Player scene is null")
	
	if number_of_players == 2:
		var player_two : Player = player_scene.instantiate()
		player_two.global_position = player_2_starting_position.global_position
		player_two.move_up_action = move_up_action2
		player_two.move_down_action = move_down_action2
		player_two.move_left_action = move_left_action2
		player_two.move_right_action = move_right_action2
		player_two.jump_action = jump_action2
		player_two.attack_action = attack_action2
		player_two.rope_action = rope_action2
		player_two.flare_action = flare_action2
		player_two.latch_action = latch_action2
		player_two.menu_action = menu_action2
		add_child(player_two)
		players.append(player_two)
		
		camera.players = players
	
	for player in players:
		print(player.name)
		snow.wind_changed.connect(player._on_snow_wind_changed)
		player.screen_exited.connect(_on_player_screen_exited)


func _on_player_screen_exited(respawning_player: Player) -> void:
	if players.size() < 2:
		return
	
	for player in players:
		if player == respawning_player:
			for other_player in players:
				if other_player != respawning_player:
					var respawn_position : Vector2 = other_player.global_position
					player.respawn(respawn_position)


func _on_flag_reached() -> void:
	print("You win!")
