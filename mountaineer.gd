class_name Mountaineer
extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -300.0

var can_move: bool = true
var end: Vector2
var end_addition := Vector2(-100, -100)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var rope: Rope = $Rope


func _physics_process(delta: float) -> void:
	if can_move == false:
		return
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		if direction == -1:
			sprite_2d.flip_h = false
		if direction == 1:
			sprite_2d.flip_h = true
		velocity.x = direction * SPEED
		animation_player.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation_player.play("idle")
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
		if velocity.y < 0:
			animation_player.play("jump")
		else:
			animation_player.play("fall")

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		if not is_on_floor():
			return
		
		can_move = false
		animation_player.play("attack")
		await animation_player.animation_finished
		can_move = true
	
	if event.is_action_pressed("rope"):
		#TODO better if check here for if rope area collision etc
		if not is_on_floor():
			return
		
		can_move = false
		animation_player.play("rope_cast")
		end = end_addition
		rope.cast(Vector2.ZERO, end)
		await animation_player.animation_finished
		
		#TODO if check here to make sure still riding?
		animation_player.play("rope_ride")
		await animation_player.animation_finished
		can_move = true
