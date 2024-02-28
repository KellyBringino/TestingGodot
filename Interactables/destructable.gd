extends StaticBody2D

var fading = false
@onready var anim = get_node("AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("Default")

func destroy():
	if !fading:
		fading = true
		$CollisionShape2D.set_deferred("disabled", true)
		anim.play("Destroy")
		await anim.animation_finished
		self.queue_free()
