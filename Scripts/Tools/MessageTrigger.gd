extends Node2D

export var messageTitle = "no title"
export var messageBody = "no body"
export var triggeredInAir = false
export var oneShot = true

func _on_Area2D_body_entered(body):
	if body.name == "Player" or (triggeredInAir && body.name == "notPlayer"):
		Hud.showMessage(messageTitle,messageBody)
		if oneShot:
			queue_free()
