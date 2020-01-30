extends Node2D

#Written by Seth Ciancio 12/7/19

export var damage = false
export var triggeredWhileJumping = true

onready var collect : collectable = collectable.new()
#this activates when a player walks onto the button

func _ready():
	collect.connect("entered",self,"entered")

func entered():
	if !damage:
			main.coins += 1 #iterate coins variable by one
	else:
			main.playerHealth -= 1
	
	queue_free()


func _on_Area2D_body_entered(body):
	collect.entered(body)