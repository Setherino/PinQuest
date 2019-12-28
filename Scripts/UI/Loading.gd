extends Control
#loading screen script
#written by Seth Ciancio
#12/27/2019

#we start with the default level, so that
#if something goes wrong, the player is just kicked to the
#main menu, and the game doesn't crash or anything.
var level = "res://UI/mainMenu.tscn"

onready var anim1 = get_node("canv/PanelContainer/pnlPlayer")
onready var anim2 = get_node("canv/contain/txtPlayer")

#this is what actually loads the next scene, it needs to be in it's
#own function so it can be triggered by the timers signal
func next_scene():
	var file = File.new()
	var location = level.insert(6,"temp/")
	
	#checking the temp folder for the scene
	if file.file_exists(location):
		print("loading from temp...")
		get_tree().change_scene(location)
	else:
		get_tree().change_scene(level)
	
	var t = Timer.new()
	add_child(t)
	t.set_wait_time(1)
	t.set_one_shot(true)
	#we wait for .1 seconds, and then load the next scene.
	#this gives the engine time to actually render the loading screen.
	t.connect("timeout",self,"queue_free")
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

#takes a file name and returns the file's directory
func getDir(var fileName):
	var lastSlash = fileName.find_last("/")
	
	fileName.erase(lastSlash,fileName.length()-lastSlash)
	
	return fileName



func saveToTemp():
	var packedScene = PackedScene.new() #create a new packed scene resource
	packedScene.pack(get_tree().get_current_scene()) #fill it with the current scene
	
	#get it's (the current scene's) location.
	var saveLocation = str(get_tree().get_current_scene().filename)
	
	#modify it's location to inculde a "temp/" in front...
	
	if saveLocation.find("res://temp/",0) == -1: #if it doesn't have temp/
		saveLocation = saveLocation.insert(6,"temp/") #add it.
		#we insert it in place 6 so it looks like: "res://temp/level..."
		#                                      so,  123456temp/...
	
	#print newly modified saveLocation
	print("attempting to save in... " + saveLocation)
	
	var directory = Directory.new() #making a new directory object
	var file = File.new() #create a new file object
	
	print("looking for directory " + getDir(saveLocation))
	if directory.dir_exists(getDir(saveLocation)):
		print("Directory exists! Moving on.")
	else:
		print("Directory doesn't exist! Making directory.")
		directory.make_dir_recursive(getDir(saveLocation))
	
	
	if file.file_exists(saveLocation): #if the file already exists
		print("save file exists already, deleting...")
		
		directory.remove(saveLocation) #delete
	
	ResourceSaver.save(saveLocation,packedScene)



#this function runs when the loading screen is created.
func _ready():
	anim1.play_backwards("fade")
	anim2.play_backwards("fade")
	
	var fact = getFact() #first we get a fun fact 
	get_node("canv/contain/facts").text = fact #and add it
	
	#save the current level, so that if the player comes back it's all the same.
	saveToTemp()
	
	
	#now we make a timer
	var t = Timer.new()
	add_child(t)
	t.set_wait_time(1)
	t.set_one_shot(true)
	#we wait for .1 seconds, and then load the next scene.
	#this gives the engine time to actually render the loading screen.
	t.connect("timeout",self,"next_scene")
	t.start()
	