extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _ready():
	print("coin spawned")

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		print(main.futureRewards[main.coins])
		main.coins = main.coins + 1
		queue_free()
