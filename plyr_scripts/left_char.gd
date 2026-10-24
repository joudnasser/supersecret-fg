extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -300.0
var cur_velocity = 0
var jumpable = 2
var jumping = false
var timeout = 100000
func _physics_process(delta: float) -> void:
	#handle_movement(delta)
	pass

func handle_animations(vel):
	if vel.x && is_on_floor():
		$"leftchar-anim".play("walk", SPEED/100)
		$"leftchar-anim".flip_h = (vel.x<0)
	elif not jumping:
		$"leftchar-anim".play("default")
		
func perform_jump():
	velocity.y = JUMP_VELOCITY
	jumpable-=1

func handle_movement(delta: float) -> void:
		# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() || jumpable>0):
		jumping=true
		perform_jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction && is_on_floor():
		velocity.x = direction * SPEED
		cur_velocity = direction * SPEED
	elif not is_on_floor(): 
		velocity.x = cur_velocity
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		cur_velocity=0
		
	if is_on_floor():
		jumpable=2
		jumping=false

	handle_animations(velocity)
	move_and_slide()
