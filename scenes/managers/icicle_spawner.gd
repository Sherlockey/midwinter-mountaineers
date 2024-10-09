class_name IcicleSpawner
extends Node

@export var min_spawn_time : float = 5.0
@export var max_spawn_time : float = 8.0
@export var icicle_scene : PackedScene

var tile_map_layer : TileMapLayer = null
var ice_block_array : Array
var player: Player = null
var icicle_y_offset : float = 12.0

@onready var timer: Timer = $Timer


func _ready() -> void:
	await get_tree().process_frame
	tile_map_layer = owner.tile_map_layer
	player = owner.player
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
	# TODO make sure the Ice_Block is still valid as in it is not disabled by the player destroying it
	# TODO make sure there is not already an Icicle that is a child of this Ice_Block
	# TODO spawn more Icicles?
	var valid_ice_blocks : Array[IceBlock] = []
	for ice_block : IceBlock in ice_block_array:
		if ice_block.global_position.y < player.position.y:
			valid_ice_blocks.append(ice_block)
	var icicle : Node = icicle_scene.instantiate()
	var random_valid_ice_block : IceBlock = valid_ice_blocks[randi_range(0, valid_ice_blocks.size() - 1)]
	random_valid_ice_block.add_child(icicle)
	icicle.global_position.y += icicle_y_offset


func populate_ice_block_array() -> void:
	for child in tile_map_layer.get_children():
		if child is IceBlock:
			#print(child.global_position)
			var check_vector = Vector2i(child.global_position.x, child.global_position.y + 12)
			print(check_vector)
			#print(tile_map_layer.get_cell_source_id(check_vector))
			if not tile_map_layer.get_cell_source_id(tile_map_layer.local_to_map(check_vector)) > -1:
				print("there is a tile on this cell")
				ice_block_array.append(child)
