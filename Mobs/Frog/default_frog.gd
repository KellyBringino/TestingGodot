class_name Frog
extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const SPEED = 100.0
const STOP_SPEED = 300.0
const jumpBoost = 400

var chase = false
var fading = false
var jumpTimer = false
var health = 1.0
var damage = 3.0
var headBounce = 300
var damageBounce = 200

@onready var player = get_node("../../Player/Player")
@onready var anim = get_node("AnimationPlayer")

func _ready():
	anim.play("Idle")
	print("Spawning frog that is")

func _physics_process(delta):
	if !fading:
		#basic physics and movement
		if not is_on_floor():
			velocity.y += gravity * delta
		else:
			move()
		
		#handle animation
		if velocity.y < 0:
			anim.play("Jump")
		elif velocity.y > 0:
			anim.play("Fall")
		else:
			anim.play("Idle")
		
		#flip sprite when moving
		if velocity.x > 0:
			get_node("AnimatedSprite2D").flip_h = true
		elif velocity.x < 0:
			get_node("AnimatedSprite2D").flip_h = false
		
		#make sure frog can move
		move_and_slide()

#when frog can see the player
func _on_player_detection_body_entered(body):
	if body.editor_description.contains("Player"):
		chase = true

#when frog cant see player
func _on_player_detection_body_exited(body):
	if body.editor_description.contains("Player"):
		chase = false

#when player jumps on frogs head
func _on_player_death_body_entered(body):
	if body.editor_description.contains("Player") && !fading:
		var direction = (player.position - self.position).normalized()
		body.throw(direction * headBounce)
		health -= 1
		if health <= 0:
			death("Death")

#when player runs into frog
func _on_player_collision_body_entered(body):
	if body.editor_description.contains("Player") && !fading:
		damagePlayer(body)

#damage the player
func damagePlayer(body):
	var direction = (player.position - self.position).normalized()
	body.throwAndDamage(direction * damageBounce, damage)

#move frog when on the ground
func move():
	velocity.x = move_toward(velocity.x, 0, STOP_SPEED)
	if chase && is_on_floor() && jumpTimer:
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			velocity = Vector2(1.0,-1.0).normalized() * jumpBoost
		elif direction.x < 0:
			velocity = Vector2(-1.0,-1.0).normalized() * jumpBoost
		jumpTimer = false
		anim.play("Jump")
		$Timer.start()

#when frog dies
func death(animName):
	fading = true
	get_node("CollisionShape2D").set_deferred("disabled", true)
	anim.play(animName)
	await anim.animation_finished
	self.queue_free()

func trap():
	health = 0
	death("Death")

func _on_timer_timeout():
	jumpTimer = true
