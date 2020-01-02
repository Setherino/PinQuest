extends Control

var next = "res://UI/mainMenu.tscn"

var stream : VideoStream

var fileLocation = "res://Misc/cutscenes/temp.webm"

func _ready():
	Hud.hideHud()
	var file = File.new()
	
	if file.file_exists("res://introWatched.nothing"):
		pass
	else:
		get_node("CanvasLayer/Button").set_disabled(true)
		file.open("res://introWatched.nothing",2)
		file.store_line("hey! Don't look at this dummy! It's just here so the game knows whether or not to let you skip the cutscene!")

func _on_Button_pressed():
	get_tree().change_scene(next)


func _on_VideoPlayer_finished():
	get_tree().change_scene(next)
