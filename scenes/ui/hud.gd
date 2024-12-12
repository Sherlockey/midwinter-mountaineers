class_name HUD
extends CanvasLayer

@onready var player_one_container: HBoxContainer = $HBoxContainer/PlayerOneContainer
@onready var player_two_container: HBoxContainer = $HBoxContainer/PlayerTwoContainer
@onready var player_one_score: Label = %PlayerOneScore
@onready var player_two_score: Label = %PlayerTwoScore

var player_one_score_value : int = 0
var player_two_score_value : int = 0


func setup(number_of_players: int, player_scores: Array[int]) -> void:
	if number_of_players == 1:
		player_two_container.hide()
	
	#TODO work on this
	player_one_score_value = player_scores[0]
	player_one_score.text = str(player_scores[0])
	if player_scores.size() > 1:
		player_two_score_value = player_scores[1]
		player_two_score.text = str(player_scores[1])


func _on_player_one_fruit_collected(value: int) -> void:
	player_one_score_value += value
	player_one_score.text = str(player_one_score_value)


func _on_player_two_fruit_collected(value: int) -> void:
	player_two_score_value += value
	player_two_score.text = str(player_two_score_value)
