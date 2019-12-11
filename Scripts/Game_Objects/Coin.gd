extends Node2D

#Written by Seth Ciancio 12/7/19

#this activates when a player walks onto the button
func _on_Area2D_body_entered(body):
	if body.name == "Player": #if it's the player
		#print(main.futureRewards[main.coins]) #print stuff
		main.coins += 1 #iterate coins variable by one
		queue_free()
