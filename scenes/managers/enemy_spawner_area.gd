extends Area2D

@export var enemy_scene : PackedScene

@onready var spawn_location: Marker2D = $SpawnLocation


func _ready() -> void:
	await get_tree().process_frame
	spawn_enemy()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		spawn_enemy()


func spawn_enemy() -> void:
	var enemy = enemy_scene.instantiate()
	get_tree().get_root().add_child(enemy)
