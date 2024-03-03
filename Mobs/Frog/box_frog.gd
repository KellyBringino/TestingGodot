extends Frog

var protected = true
var jumpPoint

func _ready():
	health = 1.0
	super._ready()
	anim.play("Idle_Box")
	print("blue")

func physicsAnims():
	if protected:
		if velocity.y < 0:
			anim.play("Jump_Box")
		elif velocity.y > 0:
			anim.play("Fall_Box")
		else:
			if anim.current_animation != "Idle_Box":
				anim.play("Idle_Box")
	else:
		super.physicsAnims()

func move():
	velocity.x = move_toward(velocity.x, 0, STOP_SPEED)
	
	if chase && jumpTimer:
		match curState:
			State.IDLE:
				jumpPoint = $Rays/upRay.get_collision_point()
				curState = State.JUMPING
			State.JUMPING:
				jumpPoint = player.global_position
				curState = State.ATTACKING
		jumpTimer = false
		$TongueNode.extend(jumpPoint)
		stuck = true
	
	if stuck:
		global_position = global_position.move_toward(jumpPoint,5.0)
		if global_position.distance_to(jumpPoint) <= 5:
			$TongueNode.reached()
			$Timer.start()
			if curState == State.ATTACKING:
				stuck = false
				curState = State.IDLE

#when frog dies
func death(animName):
	Game.frogDefeated("box")
	super.death(animName)

func _on_player_death_body_entered(body):
	if !protected:
		super._on_player_death_body_entered(body)

func destroy():
	anim.play("Box_Destroyed")
	curState = State.STUNNED
	await anim.animation_finished
	curState = State.IDLE
	protected = false
