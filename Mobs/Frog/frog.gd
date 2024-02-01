extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var chase = false
var SPEED = 100.0
var STOP_SPEED = 300.0
var fading = false
var headBounce = 300
var damageBounce = 200

func _ready():
	get_node("AnimatedSprite2D").play("Idle")
	player = get_node("../../Player/Player")

func _physics_process(delta):
	if !fading:
		#basic physics
		if not is_on_floor():
			velocity.y += gravity * delta
		
		#movement
		var direction = (player.position - self.position).normalized()
		if direction.x != 0 && chase == true:
			velocity.x = direction.x * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, STOP_SPEED)
		
		#handle animation
		if velocity.x != 0:
			get_node("AnimatedSprite2D").play("Jump")
		else:
			get_node("AnimatedSprite2D").play("Idle")
		
		#flip sprite when moving
		if velocity.x > 0:
			get_node("AnimatedSprite2D").flip_h = true
		elif velocity.x < 0:
			get_node("AnimatedSprite2D").flip_h = false
		
		#make sure frog can move
		move_and_slide()

#when frog can see the player
func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true

#when frog cant see player
func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false

#when player jumps on frogs head
func _on_player_death_body_entered(body):
	if body.name == "Player" && !fading:
		var direction = (player.position - self.position).normalized()
		body.velocity += direction * headBounce
		death()

#when player runs into frog
func _on_player_collision_body_entered(body):
	if body.name == "Player" && !fading:
		body.damage(3)
		var direction = (player.position - self.position).normalized()
		body.velocity += direction * damageBounce
		death()

#when frog dies
func death():
	Game.Gems += 3
	Utils.saveGame()
	fading = true
	get_node("CollisionShape2D").set_process(false)
	get_node("AnimatedSprite2D").play("Death")
	await get_node("AnimatedSprite2D").animation_finished
	self.queue_free()
