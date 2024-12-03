class_name Flag
extends Area2D

signal reached(number_of_players_reached: int)

@export var flag_2_texture : Texture

var finished_players : Array[Player] = []

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if not finished_players.has(body):
			finished_players.append(body)
			
			body.is_vulnerable = false
			
			if finished_players.size() < 2:
				body.state_machine.state.finished.emit(PlayerState.FLAGGING)
				body.state_machine.state.connect("flagged", _on_player_finished)
				if body.player_number == 2:
					sprite_2d.texture = flag_2_texture
			else:
				_on_player_finished()


func _on_player_finished() -> void:
	if not animation_player.is_playing():
		animation_player.play("wave")
	
	reached.emit(finished_players.size())
