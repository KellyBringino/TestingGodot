extends Node

var playerHP = 10
var Gems = 0
var currentGems = 0
var levelUnlocked = [
	2, 0, 0,
	0, 0, 0,
	0, 0, 0
]

var currentLevel = 0

func newGame():
	playerHP = 10
	Gems = 0
	levelUnlocked = [
	2, 0, 0,
	0, 0, 0,
	0, 0, 0]

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

func frogDefeated(color):
	match color:
		"green":
			currentGems += 3
		"red":
			currentGems += 4
		"gold":
			currentGems += 25

func goldCreatureDefeated():
	$"../World/Interactables/door".unlock()

func gemPickup():
	currentGems += 5

func cherryPickup():
	heal(2)

func door():
	endGame(false)

func endGame(dead):
	if !dead:
		Gems += currentGems
		if levelUnlocked[currentLevel] == 0:
			levelUnlocked[currentLevel] = 1
		Utils.saveGame()
		get_node("../World/CanvasLayer/GUI").win(currentLevel,levelUnlocked[currentLevel+1]==0,currentLevel==1)
	else:
		var keptGems = int(float(currentGems) / float(2))
		Gems += keptGems
		Utils.saveGame()
		get_node("../World/CanvasLayer/GUI").dead(keptGems)

func loadGame(level):
	currentGems = 0
	playerHP = 10
	currentLevel = level

func setLevel(number):
	currentLevel = number

func retryLevel():
	if currentLevel == 0:
		push_error("Cannot retry Main Menu")
		return
	Utils.loadLevel(currentLevel - 1)
