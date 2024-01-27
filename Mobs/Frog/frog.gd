extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var chase = false
var SPEED = 100.0
var STOP_SPEED = 300.0
var fading = false

func _ready():
	get_node("AnimatedSprite2D").play("Idle")

func _physics_process(delta):
	if !fading:
		velocity.y += gravity * delta
		player = get_node("../../Player/Player")
		var direction = (player.position - self.position).normalized()
		if direction.x != 0 && chase == true:
			get_node("AnimatedSprite2D").play("Jump")
			velocity.x = direction.x * SPEED
		else:
			
			get_node("AnimatedSprite2D").play("Idle")
			velocity.x = move_toward(velocity.x, 0, STOP_SPEED)
		
		if velocity.x > 0:
			get_node("AnimatedSprite2D").flip_h = true
		elif velocity.x < 0:
			get_node("AnimatedSprite2D").flip_h = false
		move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true

func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false


func _on_player_death_body_entered(body):
	if body.name == "Player":
		death()


func _on_player_collision_body_entered(body):
	if body.name == "Player" && !fading:
		Game.playerHP -= 3
		death()

func death():
	Game.Gold += 5
	Utils.saveGame()
	fading = true
	get_node("CollisionShape2D").set_process(false)
	get_node("AnimatedSprite2D").play("Death")
	await get_node("AnimatedSprite2D").animation_finished
	self.queue_free()
