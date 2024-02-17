extends Area2D

var unlocked = false

func _ready():
	get_node("AnimatedSprite2D").play("closed")
	unlock()

func _on_body_entered(body):
	if body.editor_description.contains("Player") && unlocked:
		Game.door()

func unlock():
	unlocked = true
	get_node("AnimatedSprite2D").play("open")
