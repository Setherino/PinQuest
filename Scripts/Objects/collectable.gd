extends Object

#written by Seth Ciancio 1/24/2020


class_name collectable

signal entered

signal exited

signal notPlayerEntered

var playerOn

var playerBody

func entered(var body):
	if main.players.has(body):
		playerOn = true
		emit_signal("entered")
		playerBody = body
	else:
		emit_signal("notPlayerEntered")


func exited(var body):
	if body.name.find("Player") != -1:
		playerOn = false
		emit_signal("exited")

