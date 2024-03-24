extends Frog

func _ready():
	super._ready()
	print("red")
	damageBounce = 400

func damagePlayer(body):
	if curState != State.FADING:
		super.damagePlayer(body)
		death("Explode")

#when frog dies
func death(animName):
	Game.frogDefeated("red")
	super.death(animName)
