extends Node

const SAVE_PATH = "res://Save/savegame.bin"

const levels = [
	"res://Levels/world.tscn",
	"res://Levels/world_2.tscn"
]

func saveGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {
		"playerHP": Game.playerHP,
		"Gems": Game.Gems,
		"Unlocked": Game.levelUnlocked
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)

func loadGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if FileAccess.file_exists(SAVE_PATH) == true:
		if not file.eof_reached():
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				Game.playerHP = current_line["playerHP"]
				Game.Gems = current_line["Gems"]
				Game.levelUnlocked = current_line["Unlocked"]

func quitGame():
	get_tree().quit()

func returnToMainMenu():
	Game.setLevel(0)
	get_tree().change_scene_to_file("res://UI/main.tscn")

func levelSelect():
	Game.setLevel(0)
	get_tree().change_scene_to_file("res://UI/level_select.tscn")

func loadLevel(number):
	print("loading level " + str(number + 1))
	Game.loadGame(number + 1)
	get_tree().change_scene_to_file(levels[number])
