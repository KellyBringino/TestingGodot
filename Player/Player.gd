extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var fading = false
var stunned = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimationPlayer")

func _ready():
	anim.play("Idle")
	Game.playerHP = 10

func _physics_process(delta):
	if !fading:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor() and !stunned:
			velocity.y = JUMP_VELOCITY
			anim.play("Jump")

		# Get the input direction and handle the movement/deceleration.
		if !stunned:
			var direction = Input.get_axis("ui_left", "ui_right")
			if direction == -1:
				get_node("AnimatedSprite2D").flip_h = true
			elif direction == 1:
				get_node("AnimatedSprite2D").flip_h = false
			
			if direction:
				velocity.x = move_toward(velocity.x,direction * SPEED,25)
				if velocity.y == 0:
					anim.play("Run")
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				if velocity.y == 0:
					anim.play("Idle")
			if velocity.y > 0:
				anim.play("Fall")

		move_and_slide()

func damage(amount):
	Game.playerHP -= amount
	if Game.playerHP < 0:
		Game.playerHP = 0
	anim.play("Hurt")
	stunned = true
	await anim.animation_finished
	stunned = false
	
	if Game.playerHP <= 0 && !fading:
		anim.play("Death")
		fading = true
		await anim.animation_finished
		Utils.returnToMainMenu()

func trap(damage):
	damage(damage)
