extends Frog

func _ready():
	super._ready()
	print("purple")

func damagePlayer(body):
	if curState != State.FADING:
		super.damagePlayer(body)
		death("Death")

func move():
	pass

#when frog dies
func death(animName):
	Game.frogDefeated("purple")
	super.death(animName)
