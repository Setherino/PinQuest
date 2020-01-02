extends Node2D

#Written by Seth Ciancio 12/7/19

export var damage = false
export var triggeredWhileJumping = true

#this activates when a player walks onto the button
func _on_Area2D_body_entered(body):
	if body.name == "Player" or body.name == "notPlayer": #if it's the player
		#print(main.futureRewards[main.coins]) #print stuff
		if !triggeredWhileJumping:
			if body.name == "notPlayer":
				return
		
		if !damage:
			main.coins += 1 #iterate coins variable by one
		else:
			main.playerHealth -= 2
		queue_free()
