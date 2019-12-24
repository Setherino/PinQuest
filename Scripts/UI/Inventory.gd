
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


#displays header
func header():
	var taskDisplay = head.instance() #create header instance
	taskDisplay.advanced = true #set that instance to advanced (see Scripts/UI/Task.gd)
	get_node("CanvasLayer/TabContainer/Tasks/Split/TopContainer/CurrentContainer").add_child(taskDisplay)
	#adds child to current container (for the current task)

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
	taskDisplay.get_node("Type").text = task.get_line()
	taskDisplay.get_node("Goal").text = task.get_line()
	taskDisplay.get_node("TimeLimit").text = task.get_line()
	taskDisplay.get_node("Ammount").text = task.get_line()
	
	#place is it's place in the list, this is used in the element (see Scripts/UI/inventoryTask.gd)
	taskDisplay.place = place
	
	#add the element to the scrolling VContainaer
	get_node("CanvasLayer/TabContainer/Tasks/Split/Scroll/VContainer").add_child(taskDisplay)

#previously selected task (used for updating the current task)
var prevID = -1

func _process(delta):
	if main.taskID != prevID: #if the current ID has changed (it's changed by the inventoryTask elements)
		prevID = main.taskID #reset prevID
		if desc.is_open(): #if the desc file is open
			desc.close() #close it
		
		#open desc to the current taskID's location (stored in an array in main.gd)
		desc.open(main.taskFileNames[main.taskID],1)
		
		var line = ""
		
		#go through until you get to the end or the description
		while line != "-DESCRIPTION:" && !desc.eof_reached():
			line = desc.get_line()
		
		#if the description was found...
		if !desc.eof_reached():
			#get that line and set the current description text
			get_node("CanvasLayer/TabContainer/Tasks/Split/TopContainer/descriptionText").text = desc.get_line()

#when the inventory is created
func _ready():
	#updating coins and task bars & labels
	#oh god this is awful, why did I do it like this??
	print (str(main.questCoins) + " " + str(main.questTasks))
	get_node("CanvasLayer/TabContainer/Quest/VBoxContainer/HBoxContainer/Label").text = str(main.coins) + "/" + str(main.questCoins) + " Coins collected"
	get_node("CanvasLayer/TabContainer/Quest/VBoxContainer/HBoxContainer/CoinsBar").value = main.coins
	get_node("CanvasLayer/TabContainer/Quest/VBoxContainer/HBoxContainer/CoinsBar").max_value = main.questCoins
	
	get_node("CanvasLayer/TabContainer/Quest/VBoxContainer/HBoxContainer2/Label").text = str(main.AmmountOfTasksComplete) + "/" + str(main.questTasks) + " Coins collected"
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