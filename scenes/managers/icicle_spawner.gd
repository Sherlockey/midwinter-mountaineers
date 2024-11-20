class_name IcicleSpawner
extends Node

@export var min_spawn_time : float = 3.0
@export var max_spawn_time : float = 5.0
@export var icicle_scene : PackedScene

var tile_map_layer : TileMapLayer = null
var ice_block_array : Array
var players: Array[Player] = []
var icicle_y_offset : float = 12.0

@onready var timer: Timer = $Timer


func _ready() -> void:
	await get_tree().process_frame
	tile_map_layer = owner.tile_map_layer
	players = owner.players
	assert(tile_map_layer != null, "The IcicleSpawner type must be used only in the level scene. It needs the owner to have a TileMapLayer node.")
	
	populate_ice_block_array()
	create_timer()


func create_timer() -> void:
	timer.wait_time = (randf_range(min_spawn_time, max_spawn_time))
	timer.start()


func _on_timer_timeout() -> void:
	spawn_icicle()
	create_timer()


func spawn_icicle() -> void:
	# Choose a valid IceBlock that is above the player, is enabled, and doesn't already have an icicle
	var valid_ice_blocks : Array[IceBlock] = []
	for ice_block : IceBlock in ice_block_array:
		for player in players:
			if ice_block.global_position.y < player.global_position.y and not ice_block.is_disabled and not ice_block.has_icicle:
				valid_ice_blocks.append(ice_block)
	if valid_ice_blocks.size() == 0:
		return
	var chosen_ice_block : IceBlock = valid_ice_blocks[randi_range(0, valid_ice_blocks.size() - 1)]
	
	# Instantiate icicle, set its position, connect signals, and inject dependencies
	var icicle : Icicle = icicle_scene.instantiate()
	chosen_ice_block.add_child(icicle)
	chosen_ice_block.has_icicle = true
	icicle.dropped.connect(chosen_ice_block._on_icicle_dropped)
	icicle.ice_block_parent = chosen_ice_block
	icicle.global_position.y += icicle_y_offset


func populate_ice_block_array() -> void:
	for child in tile_map_layer.get_children():
		if child is IceBlock:
			var check_vector := Vector2i(child.global_position.x, child.global_position.y + 12)
			if not tile_map_layer.get_cell_source_id(tile_map_layer.local_to_map(check_vector)) > -1:
				ice_block_array.append(child)
