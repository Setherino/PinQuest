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
	if times > 0 and body.name == "Player":
		main.forceJump = true
		times -= 1
		main.jumpHeight = 1
		main.slowcoin = coinsInBox
		partic.set_emitting(true)
		partic.restart()
		if times == 0:
			colission.queue_free()
			sprite.visible = false
			var t = Timer.new()
			t.set_wait_time(2)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			print("deleting")
			queue_free()

func _on_top_body_exited(body):
	main.jumpHeight = 0
	main.forceJump = false
