extends Node

var playerHP = 10
var Gems = 0
var levelUnlocked = [
	true, false, false,
	false, false, false,
	false, false, false
]

func heal(amount):
	if playerHP < 10:
		playerHP += amount
		if playerHP > 10:
			playerHP = 10

func frogDefeated():
	Game.Gems += 3
	Utils.saveGame()

func gemPickup():
	Gems += 5
