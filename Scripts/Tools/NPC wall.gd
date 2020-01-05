extends Area2D

export var blockNPC = "name"


func _on_NPC_wall_body_entered(body):
	if body.name == blockNPC:
		print("entered")
		body.changeDirection = true


func _on_NPC_wall_body_exited(body):
	if body.name == blockNPC:
		print("left")
		body.changeDirection = false
