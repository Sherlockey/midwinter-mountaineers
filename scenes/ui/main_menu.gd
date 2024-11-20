class_name MainMenu
extends Control

@export var level_one_scene : PackedScene

@onready var high_score_label: Label = %HighScoreLabel
@onready var top_scorer_label: Label = %TopScorerLabel


func _ready() -> void:
	assert(level_one_scene != null, "Level_One export var is empty! in MainMenu")


func _on_play_button_pressed() -> void:
	var level : LevelOne = level_one_scene.instantiate() as LevelOne
	get_tree().root.add_child(level)
	queue_free()


func _on_play_coop_button_pressed() -> void:
	var level : LevelOne = level_one_scene.instantiate() as LevelOne
	level.number_of_players = 2
	get_tree().root.add_child(level)
	queue_free()


func _on_exit_game_button_pressed() -> void:
	get_tree().quit()
