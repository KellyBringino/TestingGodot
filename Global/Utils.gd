extends Node

const SAVE_PATH = "res://savegame.bin"

const levels = [
	"res://Levels/world.tscn"
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

func returnToMainMenu():
	get_tree().change_scene_to_file("res://UI/main.tscn")

func levelSelect():
	get_tree().change_scene_to_file("res://UI/level_select.tscn")

func loadLevel(number):
	get_tree().change_scene_to_file(levels[number])
