extends Area2D

var unlocked = false
var entered = false

func _ready():
	get_node("AnimatedSprite2D").play("closed")

func _on_body_entered(body):
	if body.editor_description.contains("Player") && unlocked && !entered:
		entered = true
		Game.door()

func unlock():
	unlocked = true
	get_node("AnimatedSprite2D").play("open")
