extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var fading = false
var stunned = false
var attackUnlocked = false
var attackTimer = true
var nearbyObjects = []

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimationPlayer")

func _ready():
	anim.play("Idle")
	Game.playerHP = 10
	attackUnlocked = Game.getAttackUnlock()

func _physics_process(delta):
	if !fading:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor() and !stunned:
			jump()
		
		if Input.is_action_just_pressed("attack") && attackUnlocked && attackTimer:
			attack()

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

func jump():
	velocity.y = JUMP_VELOCITY
	anim.play("Jump")

func attack():
	stunned = true
	anim.play("Attack")
	await anim.animation_finished
	stunned = false
	anim.play("Idle")
	for index in nearbyObjects.size():
		if nearbyObjects[index].editor_description.contains("Destroy"):
			nearbyObjects[index].destroy()
	attackTimer = false
	$"Attack Timer".start()

func damage(amount):
	Game.damage(amount)
	anim.play("Hurt")
	stunned = true
	await anim.animation_finished
	stunned = false
	
	if Game.playerHP <= 0 && !fading:
		anim.play("Death")
		fading = true
		await anim.animation_finished
		Game.endGame(true)

func throw(direction):
	velocity += direction
	anim.play("Jump")

func throwAndDamage(direction,amount):
	velocity += direction
	damage(amount)

func trap():
	damage(10)

func _on_object_detect_body_entered(body):
	nearbyObjects.append(body)

func _on_object_detect_body_exited(body):
	for index in nearbyObjects.size():
		if nearbyObjects[index] == body:
			nearbyObjects.remove_at(index)
			break

func _on_attack_timer_timeout():
	attackTimer = true
