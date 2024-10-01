class_name Player
extends CharacterBody2D

var can_latch : bool = true

@export var speed := 100.0
@export var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var jump_impulse := 300.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_animation_player: AnimationPlayer = $AttackAnimationPlayer
@onready var rope: Rope = $Rope
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var state_machine: StateMachine = $StateMachine
