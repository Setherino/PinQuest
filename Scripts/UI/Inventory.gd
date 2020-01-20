
#menu/inventory script
#written by Seth Ciancio 12/18ish/19

#commented on 12/21/19 3:18AM

#yes I know it's bad practice to comment after you write it,
#but by reading this code you should know one thing about me,
#I'm not a very good programmer.

extends Control

var desc : File = File.new()
#referance for task element
const tasks = preload("res://UI/inventoryTask.tscn")

#reference for header element
const head = preload("res://UI/Task.tscn")

#the two elements are very similar (Task vs. inventoryTask)

onready var button = get_node("CanvasLayer/TabContainer/Quest/VBoxContainer/Button")

var inventoryPlacement = Rect2(100,35,847,504)

var tutorial = false

#displays header
func header():
	var taskDisplay = head.instance() #create header instance
	taskDisplay.advanced = true #set that instance to advanced (see Scripts/UI/Task.gd)
	get_node("CanvasLayer/TabContainer/Tasks/Split/TopContainer/CurrentContainer").add_child(taskDisplay)
	#adds child to current container (for the current task)


func getDesc(location):
	var file = File.new()
	
	if file.file_exists(location):
		file.open(location,1)
	else:
		return " "
	var line
	
	while line != "-DESCRIPTION:" && !file.eof_reached():
		line = file.get_line()
	
	if file.eof_reached():
		return "none"
	
	line = ""
	
	
	while !file.eof_reached():
		line += file.get_line()
		line += "\n"
	
	
	
	return line

#retuns the name based on the number stored in the file
func getType(type:int):
	match type:
		1:
			return "Collection"
		2:
			return "Talk to NPC"
		3:
			return "Delivery"
		4:
			return "Interact With"

#adds task element to list
func addTask(location:String,place):

	#create file variable
	var task : File = File.new()

	#does the supplied location exist?
	if !task.file_exists(location):
		#if not, print an error
		print("ERROR! " + location + " IS NOT A VALID TASK LOCATION!")
		return #and stop the script

	task.open(location,1)
	#open the file
	var taskDisplay = tasks.instance()
	#create an instance of the task

	#set the text for that instance, name, type, goal, time limit, and # to collect
	taskDisplay.get_node("Name").text = task.get_line()
	taskDisplay.get_node("Type").text = getType(int(task.get_line()))
	taskDisplay.get_node("Goal").text = task.get_line()
	taskDisplay.get_node("TimeLimit").text = task.get_line()
	taskDisplay.get_node("Ammount").text = task.get_line()

	#place is it's place in the list, this is used in the element (see Scripts/UI/inventoryTask.gd)
	taskDisplay.place = place
	taskDisplay.description = getDesc(location)
	#add the element to the scrolling VContainaer
	get_node("CanvasLayer/TabContainer/Tasks/Split/Scroll/VContainer").add_child(taskDisplay)
	
#previously selected task (used for updating the current task)
var prevID = -1

func _process(delta):
	if main.taskID != prevID && main.taskID != 0: #if the current ID has changed (it's changed by the inventoryTask elements)
		prevID = main.taskID #reset prevID
		#set description using getDesc
		get_node("CanvasLayer/TabContainer/Tasks/Split/TopContainer/descriptionText").text = getDesc(main.taskFileNames[main.taskID])
	elif main.taskID == 0:
		get_node("CanvasLayer/TabContainer/Tasks/Split/TopContainer/descriptionText").text = "You have no current task.\nPress 'Start Task' to start a task."
		pass

var characters = ["Dog", "Baker",
 "Elder","OfficeWorker",
"Student1","Trendy","NO",
"BusinessMan","OldBusinessMan",
"Casual","Punk","Student2",
"Student3","Robes",
"TrafficCop","NO"]


#when the inventory is created
func _ready():
	get_node("CanvasLayer/TabContainer/Options/VBoxContainer/Toggle Switches/Mute").set_pressed(!Hud.get_node("HUDElement").get_mute())
	get_node("CanvasLayer/TabContainer/Options/VBoxContainer/Toggle Switches/ChangeSong").set_pressed(main.changeOnDoor)
	
	
	get_node("CanvasLayer/TabContainer/Options/VBoxContainer/MusicVolume/Label").text = "Music Volume        (" + str(round(((30 + Hud.get_node("HUDElement").getMusicVolume()) / 30) * 100)) + "%)"
	get_node("CanvasLayer/TabContainer/Options/VBoxContainer/MusicVolume/MusicSlider").set_value(Hud.get_node("HUDElement").getMusicVolume())
	
	get_node("CanvasLayer/TabContainer/Options/VBoxContainer/SFX volume/Label").text = "Sound Effect Volume  (" + str(round(((30 + main.SFXVolume) / 30) * 100)) + "%)"
	get_node("CanvasLayer/TabContainer/Options/VBoxContainer/SFX volume/SFXVolume").set_value(main.SFXVolume)
	
	get_node("CanvasLayer/TabContainer/Options/VBoxContainer/PlayerModel/Label").text = "Selected Player Model: " + characters[main.playerCharacter]
	
	
	get_node("CanvasLayer/TabContainer").set_position(inventoryPlacement.position)
	get_node("CanvasLayer/TabContainer").set_size(inventoryPlacement.size)
	
	#updating coins and task bars & labels
	#oh god this is awful, why did I do it like this??
	get_node("CanvasLayer/TabContainer/Quest/VBoxContainer/HBoxContainer/Label").text = str(main.coins) + "/" + str(main.questCoins) + " Coins collected"
	get_node("CanvasLayer/TabContainer/Quest/VBoxContainer/HBoxContainer/CoinsBar").value = main.coins
	get_node("CanvasLayer/TabContainer/Quest/VBoxContainer/HBoxContainer/CoinsBar").max_value = main.questCoins

	get_node("CanvasLayer/TabContainer/Quest/VBoxContainer/HBoxContainer2/Label").text = str(main.AmmountOfTasksComplete) + "/" + str(main.questTasks) + " Tasks complete"
	get_node("CanvasLayer/TabContainer/Quest/VBoxContainer/HBoxContainer2/TasksBar").value = main.AmmountOfTasksComplete
	get_node("CanvasLayer/TabContainer/Quest/VBoxContainer/HBoxContainer2/TasksBar").max_value = main.questTasks

	header() #create header
	#loop through the entire array

	if main.AmmountOfTasksComplete >= main.questTasks && main.coins >= main.questCoins:
		button.disabled = false
	else:
		button.disabled = true
	var i = 0 #create iterator variable
	while i < main.taskFileNames.size():
		#add a task element for each item
		addTask(main.taskFileNames[i],i)
		i = i + 1 #iterate iterator

func getMessage():
	var message
	message = "You've finished the level, great job!"
	if main.levelFolder == "Debug":
		message = "You've finished the tutorial, great job!"
	elif main.levelFolder == "LevelOne":
		pass
	elif main.levelFolder == "LevelTwo":
		pass
	elif main.levelFolder == "LevelThree":
		pass
	elif main.levelFolder == "LevelFour":
		message = "You've finished the game, great job! \n Press the button to go back to the main menu."
	
	
	return message



#when the "complete quest" button is pressed...
func _on_Button_pressed():
	Hud.levelDone(getMessage(),main.nextLevel)


func _on_HSlider_value_changed(value):
	get_node("CanvasLayer/TabContainer/Options/VBoxContainer/HBoxContainer/Label").text = "VHS Damage Effect (" + str(round(value)) + ")"
	main.vhsEffect = round(value)


func _on_changeModel_pressed():
	Hud.characterSelect(Hud.saveToTemp())
	

func _on_Quit_pressed():
	get_tree().quit()

func _on_SFXVolume_value_changed(value):
	get_node("CanvasLayer/TabContainer/Options/VBoxContainer/SFX volume/Label").text = "Sound Effect Volume  (" + str(round(((30 + value) / 30) * 100)) + "%)"
	get_node("sfx").set_volume_db(value-10)
	get_node("sfx").play()
	if value == -30:
		main.SFXVolume = -80
	else:
		main.SFXVolume = value
	pass
	
	main.updateVolume()

func _on_MusicSlider_value_changed(value):
	get_node("CanvasLayer/TabContainer/Options/VBoxContainer/MusicVolume/Label").text = "Music Volume        (" + str(round(((30 + value) / 30) * 100)) + "%)"
	if Hud.has_node("HUDElement"):
		if value == -30:
			Hud.get_node("HUDElement").setMusicVolume(-80)
		else:
			Hud.get_node("HUDElement").setMusicVolume(value)
		pass


func _on_Mute_toggled(button_pressed):
	Hud.get_node("HUDElement").set_mute(!button_pressed)


func _on_ChangeSong_toggled(button_pressed):
	main.changeOnDoor = button_pressed


func _on_Shuffle_pressed():
	Hud.get_node("HUDElement").musicStreams.shuffle()
	Hud.get_node("HUDElement").changeSong(-1)
