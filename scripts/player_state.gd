class_name PlayerState
extends State

const IDLE = "Idle"
const RUNNING = "Running"
const JUMPING = "Jumping"
const FALLING = "Falling"
const ATTACKING = "Attacking"
const ATTACKING_RUNNING = "AttackingRunning"
const ROPE_CASTING = "RopeCasting"
const ROPE_CASTING_RUNNING = "RopeCastingRunning"
const ROPE_CASTING_JUMPING = "RopeCastingJumping"
const ROPE_RIDING = "RopeRiding"
const FLARING = "Flaring"
const FLARING_RUNNING = "FlaringRunning"
const FLARING_JUMPING = "FlaringJumping"
const LATCHING = "Latching"

var player: Player


func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")
