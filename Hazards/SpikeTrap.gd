extends Area2D



func _on_body_entered(body):
	if body.editor_description.contains("Player") || body.editor_description.contains("Enemy"):
		body.trap()
