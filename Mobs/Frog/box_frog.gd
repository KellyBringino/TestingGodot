extends BlueFrog

#when frog dies
func death(animName):
	Game.frogDefeated("box")
	super.death(animName)

func destroy():
	animate("Box_Destroyed",false, false)
	curState = State.STUNNED
	await anim.animation_finished
	curState = State.IDLE
	protected = false

func _on_animated_sprite_2d_animation_looped():
	print(anim.current_animation)
