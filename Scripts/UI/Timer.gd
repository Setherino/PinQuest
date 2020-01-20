extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var time = get_node("Timer")
onready var label = get_node("Label")


var timeLimit:int = 10

var secondsPassed = 0
var secondLimit

func _ready():
	#label.text = str(round(secondsPassed/60)) + ":" + str(secondsPassed - ((secondsPassed % 60) * 60))
	secondsPassed = timeLimit * 60
	label.text = "You have " + get_time() + " minutes left to complete the level."

func get_time():
	return str(secondsPassed/60) + ":" + str(secondsPassed % 60)

func _on_Timer_timeout():
	label.text = "You have " + get_time() + " minutes left to complete the level."
	secondsPassed -= 1
	if secondsPassed <= 0:
		main.playerHealth = 0
		Hud.showMessage("Oh No!","You ran out of time to complete the level.\nYou're going to have to restart!")
		secondsPassed = timeLimit * 60
		queue_free()
