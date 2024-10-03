class_name Player
extends CharacterBody2D

@export var speed := 100.0
@export var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var jump_impulse := 325.0

var can_latch : bool = true
var can_flare : bool = true
var does_drop_through : bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_animation_player: AnimationPlayer = $AttackAnimationPlayer
@onready var rope: Rope = $Rope
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var state_machine: StateMachine = $StateMachine
@onready var drop_through_timer: Timer = $DropThroughTimer


func _on_drop_through_timer_timeout() -> void:
	does_drop_through = false
