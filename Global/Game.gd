extends Node

var playerHP = 10
var Gems = 0
var currentGems = 0
var levelUnlocked = [
	true, false, false,
	false, false, false,
	false, false, false
]

var currentLevel = 0

func newGame():
	playerHP = 10
	Gems = 0
	levelUnlocked = [
	true, false, false,
	false, false, false,
	false, false, false]

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
	currentGems += 3

func gemPickup():
	currentGems += 5

func cherryPickup():
	heal(2)

func door():
	endGame(false)

func endGame(dead):
	if !dead:
		Gems += currentGems
		Utils.saveGame()
		Utils.returnToMainMenu()
	else:
		Gems += int(float(currentGems) / float(2))
		Utils.saveGame()
		Utils.returnToMainMenu()

func setLevel(number):
	currentLevel = number

func retryLevel():
	if currentLevel == 0:
		push_error("Cannot retry Main Menu")
		return
	Utils.loadLevel(currentLevel - 1)
