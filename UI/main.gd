extends Node2D

func _ready():
	if FileAccess.file_exists(Utils.SAVE_PATH):
		Utils.loadGame()
	else:
		get_node("CanvasLayer/MarginContainer/VBoxContainer/Continue Container/Continue Button").disabled = true

func _on_continue_button_pressed():
	Utils.levelSelect()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_new_game_button_pressed():
	Utils.saveGame()
	Utils.loadGame()
	Utils.levelSelect()
