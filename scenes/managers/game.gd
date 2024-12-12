class_name Game
extends Node

@export var level_scenes: Array[PackedScene]
@export var score_scene: PackedScene

var main_menu_scene : PackedScene = preload("res://scenes/ui/main_menu.tscn")
var player_scores: Array[int] = []
var current_level : Node2D
var current_level_index: int = 0
var number_of_players : int
var save_data: SaveGame


func create_one_player_game() -> void:
	number_of_players = 1
	var level_one : LevelOne = level_scenes[0].instantiate() as LevelOne
	current_level = level_one
	current_level_index = 0
	player_scores = [0]
	level_one.number_of_players = number_of_players
	level_one.level_finished.connect(_on_level_level_finished)
	add_child(level_one)


func create_two_player_game() -> void:
	number_of_players = 2
	var level_one : LevelOne = level_scenes[0].instantiate() as LevelOne
	current_level = level_one
	current_level_index = 0
	player_scores = [0, 0]
	level_one.number_of_players = number_of_players
	level_one.level_finished.connect(_on_level_level_finished)
	add_child(level_one)


func _on_level_level_finished() -> void:
	# Update player_scores
	player_scores[0] = current_level.hud.player_one_score_value
	if number_of_players == 2:
		player_scores[1] = current_level.hud.player_two_score_value
	
	if current_level_index >= (level_scenes.size() - 1):
		# instantiate and add_child the score scene
		# tell score screen the current scores
		save_data = SaveGame.load_data()
		if save_data == null:
			save_data = SaveGame.new()
		
		var combined_scores : int = 0
		for player_score in player_scores:
			combined_scores += player_score
			
		if combined_scores > save_data.high_score:
			save_data.high_score = combined_scores
			save_data.save_data()
		
		current_level.queue_free()
		var main_menu := main_menu_scene.instantiate()
		get_tree().root.add_child(main_menu)
		queue_free()
	else:
		current_level_index += 1
		var new_level : Node2D = level_scenes[current_level_index].instantiate()
		new_level.number_of_players = number_of_players
		add_child(new_level)
		current_level.queue_free()
		current_level = new_level
		
		new_level.setup_hud(number_of_players, player_scores)
		new_level.level_finished.connect(_on_level_level_finished)
