extends Frog

func _ready():
	health = 3.0
	super._ready()
	print("gold")

#when frog dies
func death(animName):
	Game.frogDefeated("gold")
	super.death(animName)
