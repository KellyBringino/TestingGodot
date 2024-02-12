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

func damage(amount):
	if playerHP - amount <= 0:
		playerHP = 0
	else:
		playerHP -= amount

func frogDefeated():
	Game.Gems += 3

func gemPickup():
	Gems += 5

func cherryPickup():
	heal(2)
