class_name BlueFrog
extends Frog

var protected = true
var jumpPoint

func _ready():
	health = 1.0
	super._ready()
	print("blue")
	animate("Idle_Pro",true, false)

func physicsAnims():
	var dir = player.position.x - position.x
	if curState == State.ATTACKING || curState == State.STUCK:
		get_node("AnimatedSprite2D").flip_h = dir<0
	else:
		get_node("AnimatedSprite2D").flip_h = dir>0
	
	if curState != State.ATTACKING && curState != State.JUMPING && curState != State.STUCK:
		if protected:
			if velocity.y < 0:
				animate("Jump_Pro",false, false)
			elif velocity.y > 0:
				animate("Fall_Pro",false, false)
			else:
				animate("Idle_Pro",true, false)
		else:
			super.physicsAnims()

func move():
	velocity.x = move_toward(velocity.x, 0, STOP_SPEED)
	#print("chase: " + str(chase) + ", jumptimer: " + str($Timer.time_left))
	if chase && jumpTimer:
		match curState:
			State.IDLE:
				jumpPoint = $Rays/upRay.get_collision_point()
				curState = State.JUMPING
				if protected:
					animate("Attack_Pro",false, false)
				else:
					animate("Attack",false, false)
			State.STUCK:
				jumpPoint = player.global_position
				curState = State.ATTACKING
				if protected:
					animate("Attack_Down_Pro",false, false)
				else:
					animate("Attack_Down",false, false)
		jumpTimer = false
		$TongueNode.extend(jumpPoint)
		stuck = true
	
	if stuck:
		global_position = global_position.move_toward(jumpPoint,5.0)
		if global_position.distance_to(jumpPoint) <= 10:
			$TongueNode.reached()
			match curState:
				State.JUMPING:
					if protected:
						animate("Idle_Down_Pro",true, false)
					else:
						animate("Idle_Down",true, false)
					curState = State.STUCK
					$Timer.start()
					pass
				State.ATTACKING:
					stuck = false
					if protected:
						animate("Idle_Pro",true, false)
					else:
						animate("Idle",true, false)
					curState = State.IDLE
					$Timer.start()

func _on_player_death_body_entered(body):
	if !protected:
		super._on_player_death_body_entered(body)
