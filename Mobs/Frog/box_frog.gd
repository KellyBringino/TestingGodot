extends Frog

var protected = true
var jumping = false
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
		jumpPoint = $Rays/upRay.get_collision_point()
		$TongueNode.extend(jumpPoint)
		jumping = true
	
	if jumping && !stunned:
		global_position = 

#when frog dies
func death(animName):
	Game.frogDefeated("box")
	super.death(animName)

func _on_player_death_body_entered(body):
	if !protected:
		super._on_player_death_body_entered(body)

func destroy():
	anim.play("Box_Destroyed")
	stunned = true
	await anim.animation_finished
	stunned = false
	protected = false
