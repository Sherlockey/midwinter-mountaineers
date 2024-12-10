class_name LevelThree
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

@onready var snow_green: Snow = $SnowGreen
@onready var tile_map_layer: TileMapLayer = $ForegroundTileMap
@onready var icicle_spawner: IcicleSpawner
@onready var player_2_starting_position: Marker2D = $Player2StartingPosition
@onready var camera: Camera = $Camera


func _ready() -> void:
	assert(player_scene != null, "Player scene is null")
	
	# Set up player 2
	if number_of_players == 2:
		var player_2 : Player = player_scene.instantiate()
		player_2.global_position = player_2_starting_position.global_position
		player_2.move_up_action = move_up_action2
		player_2.move_down_action = move_down_action2
		player_2.move_left_action = move_left_action2
		player_2.move_right_action = move_right_action2
		player_2.jump_action = jump_action2
		player_2.attack_action = attack_action2
		player_2.rope_action = rope_action2
		player_2.flare_action = flare_action2
		player_2.latch_action = latch_action2
		player_2.menu_action = menu_action2
		
		player_2.player_number = 2
		
		add_child(player_2)
		player_2.sprite_2d.texture = player_2.player_2_texture
		players.append(player_2)
		
		# Set up camera
		camera.players = players
	
	# Set up signals for all players
	for player in players:
		print(player.name)
		snow_green.wind_changed.connect(player._on_snow_wind_changed)
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


func _on_flag_reached(number_of_players_finished: int) -> void:
	if number_of_players_finished == number_of_players:
		print("Everyone has reached the flag!")
		Engine.time_scale = 0.5
		await get_tree().create_timer(0.75, false).timeout
		Engine.time_scale = 1.0
		# TODO request next scene here instead of quitting
		get_tree().quit()
	else:
		print("Not all players are done yet")
		# TODO start a timer in HUD that counts down
