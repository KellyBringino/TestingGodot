extends Node

var playerHP = 10
var Gems = 0
var currentGems = 0
var currentLevel = 0
var attackUnlock = true
var climbUnlock = false
var lockpickUnlock = false
var boxUnlocks = [
	false,false,false
]
var climbUnlocks = [
	false,false,false,
	false,false,false
]
var pickUnlocks = [
	false,false,false,
	false,false,false,
	false,false,false
]
var levelUnlocked = [
	2, 0, 0,
	0, 0, 0,
	0, 0, 0
]

const unlockValue = [
	0, 150, 300,
	500, 700, 900,
	1000, 1200, 1500
]

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

func getAttackUnlock():
	return attackUnlock

func getClimbUnlock():
	return climbUnlock

func getLockpickUnlock():
	return lockpickUnlock

func frogDefeated(color):
	match color:
		"green":
			currentGems += 3
		"red":
			currentGems += 4
		"purple":
			currentGems += 5
		"gold":
			currentGems += 25
			goldCreatureDefeated()
		"box":
			currentGems += 10
			unlockCreatureDefeated("box")

func goldCreatureDefeated():
	$"../World/Interactables/door".unlock()

func unlockCreatureDefeated(type):
	match type:
		"box":
			boxUnlocks[currentLevel] = true
			Utils.saveGame()

func gemPickup():
	currentGems += 5

func cherryPickup():
	heal(2)

func door():
	endGame(false)

func endGame(dead):
	if !dead:
		var bonus = playerHP * 3
		Gems += (currentGems + int(bonus))
		if levelUnlocked[currentLevel] == 0:
			levelUnlocked[currentLevel] = 1
		Utils.saveGame()
		get_node("../World/CanvasLayer/GUI").win(currentLevel,levelUnlocked[currentLevel]==1,currentLevel==1,int(bonus))
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

func unlockLevel(number):
	if (levelUnlocked[number] != 1) || Gems < unlockValue[number]:
		return false
	else:
		Gems -= unlockValue[number]
		levelUnlocked[number] = 2
		Utils.saveGame()
		return true
