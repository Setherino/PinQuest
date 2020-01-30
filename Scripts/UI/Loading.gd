extends Control
#loading screen script
#written by Seth Ciancio
#12/27/2019

#we start with the default level, so that
#if something goes wrong, the player is just kicked to the
#main menu, and the game doesn't crash or anything.
var level = "res://UI/mainMenu.tscn"

var save = true
var player
onready var anim1 = get_node("canv/PanelContainer/pnlPlayer")
onready var anim2 = get_node("canv/contain/txtPlayer")

func done():
	queue_free()
	

#this is what actually loads the next scene, it needs to be in it's
#own function so it can be triggered by the timers signal
func next_scene():
	var file = File.new()
	var location = level.replace("res://","user://temp/")
	
	#checking the temp folder for the scene
	if file.file_exists(location) && save:
		print("loading from temp...")
		main.splitscreen.changeScene(location,player.playerID)
	else:
		main.splitscreen.changeScene(level,player.playerID)
	main.movementEnabled = true
	if main.changeOnDoor:
		Hud.get_node("HUDElement").changeSong(-1)
	var t = Timer.new()
	add_child(t)
	t.set_wait_time(1)
	t.set_one_shot(true)
	#we wait for .1 seconds, and then load the next scene.
	#this gives the engine time to actually render the loading screen.
	t.connect("timeout",self,"done")
	t.start()
	
	anim1.play("fade")
	anim2.play("fade")

#this function returns one of the fun facts out of the file
func getFact():
	var facts = File.new() #first it creates the file
	facts.open("res://funfacts.task",1) #then opens it
	
	#now we get the first line, which corresponds to the number of 
	#facts in the list.
	var ammount = int(facts.get_line())
	var line = ""
	
	#now we pick one of the facts at random
	randomize()
	var item = round(rand_range(1,ammount))
	
	#now we go to that fact
	for i in range(item):
		line = facts.get_line() #get the line
	
	#and return it.
	return line









#this function runs when the loading screen is created.
func _ready():
	main.movementEnabled = false
	anim1.play_backwards("fade")
	anim2.play_backwards("fade")
	
	var fact = getFact() #first we get a fun fact 
	get_node("canv/contain/facts").text = fact #and add it
	
	
	#now we make a timer
	var t = Timer.new()
	add_child(t)
	t.set_wait_time(1)
	t.set_one_shot(true)
	#we wait for .1 seconds, and then load the next scene.
	#this gives the engine time to actually render the loading screen.
	t.connect("timeout",self,"next_scene")
	t.start()
	