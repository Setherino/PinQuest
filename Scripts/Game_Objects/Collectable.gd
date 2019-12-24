extends Node2D

export var taskSource = "none"
export var texture : Texture

func _ready():
	get_node("Sprite").texture = texture

func _process(delta):
	if main.taskName != taskSource:
		queue_free()




func _on_Area2D_body_entered(body):
	if body.name == "Player":
		main.taskAmmountCollected += 1
		queue_free()
