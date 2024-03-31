extends Frog

func _ready():
	super._ready()
	print("green")

func damagePlayer(body):
	if curState != State.FADING:
		super.damagePlayer(body)
		death("Death")

#when frog dies
func death(animName):
	Game.frogDefeated("green")
	super.death(animName)
