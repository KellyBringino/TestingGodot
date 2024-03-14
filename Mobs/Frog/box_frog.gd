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
