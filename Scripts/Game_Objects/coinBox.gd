extends Node2D

#Written by Seth Ciancio 12/8/19
#We probably won't use this object but I made it anyways.
var done = false

export var coinsInBox = 10 #number of coins that the box emits
onready var sprite = get_node("Sprite")
onready var partic = get_node("CPUParticles2D")
onready var colission = get_node("StaticBody2D")



#triggered when *something* touches the top of the box
func _on_top_body_entered(body):
	if !done:
		done = true
		main.forceJump = true
		main.jumpHeight = 0
		colission.queue_free()
		main.slowcoin = coinsInBox
		sprite.visible = false
		partic.set_emitting(true)
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
