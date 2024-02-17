extends Node2D

func _ready():
	if FileAccess.file_exists(Utils.SAVE_PATH):
		Utils.loadGame()
		$"CanvasLayer/MarginContainer/VBoxContainer/Continue Container/HBoxContainer/Gem Counter/HBoxContainer/Gem Counter Container/Gem Counter Label".text =  str(Game.Gems)
	else:
		$"CanvasLayer/MarginContainer/VBoxContainer/Continue Container/HBoxContainer/Continue Button Container/Continue Button".disabled = true
		$"CanvasLayer/MarginContainer/VBoxContainer/Continue Container/HBoxContainer/Gem Counter/HBoxContainer/Gem Counter Container/Gem Counter Label".text = ""

func _on_continue_button_pressed():
	Utils.levelSelect()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_new_game_button_pressed():
	Game.newGame()
	Utils.saveGame()
	Utils.loadGame()
	Utils.levelSelect()
