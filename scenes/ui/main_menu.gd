class_name MainMenu
extends Control

@export var game_scene : PackedScene

@onready var high_score_label: Label = %HighScoreLabel
@onready var top_scorer_label: Label = %TopScorerLabel


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	
	if SaveGame.load_data() == null:
		high_score_label.text = "High Score: 00000"
	else:
		var save_data := SaveGame.load_data()
		var high_score := save_data.high_score

		high_score_label.text = "High Score: " + str(high_score)


func _on_play_button_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var game : Game = game_scene.instantiate() as Game
	get_tree().root.add_child(game)
	game.create_one_player_game()
	
	queue_free()


func _on_play_coop_button_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var game : Game = game_scene.instantiate() as Game
	get_tree().root.add_child(game)
	game.create_two_player_game()
	
	queue_free()


func _on_exit_game_button_pressed() -> void:
	get_tree().quit()
