extends Node2D

#Written by Seth Ciancio 12/8/19
#We probably won't use this object but I made it anyways.

export var coinsInBox = 10 #number of coins that the box emits
export var times = 1
onready var sprite = get_node("Sprite")
onready var partic = get_node("CPUParticles2D")
onready var colission = get_node("StaticBody2D")



#triggered when *something* touches the top of the box
func _on_top_body_entered(body):
	#if times is > zero and the thing that touches the box is the player
	print("entered")
	if times > 0 and body.name == "notPlayer":
		main.forceJump(-300)
		times -= 1 #change times by -1
		main.slowcoin = coinsInBox #slowly adds all coins to coin value (see main.gd)
		partic.set_emitting(true)  #start emiting coins
		partic.restart() #reset
		if times == 0: #if it's the last time
			colission.queue_free() #delete the collisions
			get_node("LightOccluder2D").queue_free() #delete the shadow
			sprite.visible = false #make the sprite invisible
			
			#wait for two seconds...
			var t = Timer.new() 
			t.set_wait_time(2)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			
			print("deleting")
			queue_free() #delete the sprite & the particle emmiter
			#we wait to delete it so the particles aren't deleted.

#when the player leaves the top of the box
func _on_top_body_exited(body):
	main.jumpHeight = 0 #set jumpheight modifier to 0
	main.forceJump = false #stop forcing them to jump
