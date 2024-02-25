extends Frog

func _ready():
	super._ready()
	print("red")
	damageBounce = 400

func damagePlayer(body):
	super.damagePlayer(body)
	death("Explode")

#when frog dies
func death(animName):
	Game.frogDefeated("red")
	super.death(animName)

func _on_timer_timeout():
	jumpTimer = true
