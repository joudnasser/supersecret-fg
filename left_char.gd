extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -200.0
var cur_velocity = 0
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction && is_on_floor():
		velocity.x = direction * SPEED
		cur_velocity = direction*SPEED
	elif not is_on_floor(): 
		velocity.x = cur_velocity
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		cur_velocity=0
		
	if velocity.x && is_on_floor():
		$"leftchar-anim".play("walk", SPEED/100)
		$"leftchar-anim".flip_h = (direction<0)
	elif not is_on_floor():
		$"leftchar-anim".play("jump")
	else:
		$"leftchar-anim".play("default")

	move_and_slide()
