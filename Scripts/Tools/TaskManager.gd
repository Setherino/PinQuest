#TASK MAN SCRIPT
#BY SETHERINO CIANCIO (pronounced CHAHN-CHO, by the way.)
#you don't get a date for this one. How does that make you feel?
#it was made the same day as the task.gd script, and idk what day that was
#because it's a few days (mb a week?) later. Oh, you know what, it was last sunday.
#saturday?
#I can look through the insta messages. WAIT NO I CANT I ACCIDENTLY DELETED THEM ON THURSDAY!!!
#ugh. Well today is 12/21/19, this was probably written on the 15th

#I just checked the folders, and yes, the 15th.
#so you do get a date, even though you don't deserve one.
#just kidding you deserve the world, buddy! I love you, always.
#please just, no matter where you go, never forget that, okay? Never forget how much I love you.
#don't forget me...
#someone said that to me once, but for the life of me I can't remember their name...

tool
extends Node2D

#here are all the elements that the level designer can modify to create tasks...

#the folder where the task tile is stored
export(String, "Debug", "LevelOne", "LevelTwo","LevelThree","LevelFour") var Folder setget setfolder

#its name
export var taskFileNames :Array 

export var showTasks = false setget hideShow

#this is the button to display the tasks
var taskShow = false 

#this button clears them
var hideTasks = false

#the number of tasks / coins required to complete the level
export var questTasksRequired = 0
export var questCoinsRequired = 0

 #the location of next level
export var nextLevel = "level2"

#loads task element so we can create them later
const tasks = preload("res://UI/Task.tscn")

func setfolder(var folder):
	taskFileNames.clear()
	Folder = folder
	autofill()

func hideShow(var show):
	showTasks = show
	if show:
		taskShow = true
	else:
		killChildren(true)

#lol
func killChildren(var del):
	main.deleteTaskList = del

#run when level starts
func _ready():
	if Engine.editor_hint:
		var t = Timer.new()
		t.set_wait_time(5)
		t.set_one_shot(false)
		t.connect("timeout",self,"autofill")
		add_child(t)
		t.start()
	
	
	#if we're not in the engine
	if !Engine.editor_hint:
		#update the number of coins & tasks required
		main.questCoins = questCoinsRequired
		main.questTasks = questTasksRequired
		
		#if this is the first time loading the level...
		if main.levelFolder == "na":
			main.levelFolder = Folder #set this to the correct folder
			
			#clear all the task arrays.
			main.tasksComplete.clear() 
			main.taskStarted.clear()
			main.taskFileNames.clear()
		else:#if it's not the first time
			return #stop the script
		
		#set the global nextLevel variable
		main.nextLevel = nextLevel
		
		#loop through the array of tasks
		var iterate = 0
		while iterate < taskFileNames.size(): #loop for number of taskFiles there are
			#adds to array of taskfile locations (with actual location)
			main.taskFileNames.append("res://Tasks/" + Folder + "/"+ taskFileNames[iterate] + ".task")
			main.tasksComplete.append(false) #it's not complete yet, the game just started
			main.taskStarted.append(false) #it also hasn't been started yet, so.
			print(main.taskFileNames[iterate])
			iterate += 1



#adds the header task to the list of task elements
func makeHeader():
	addTask("res://Tasks/Header.task")

#creates the aformentioned task elements
func addTask(location:String):
	#create file var to open task files with
	var task : File = File.new()
	
	#if the taskfile doesnt exist
	if !task.file_exists(location):
		#print an error
		print("ERROR! " + location + " IS NOT A VALID TASK LOCATION!")
		return #and end the function
	
	#open the file at the given location
	task.open(location,1)
	#create an instance of the task element
	var taskDisplay = tasks.instance()
	
	#fill that instance with all the correct information
	taskDisplay.get_node("Name").text = task.get_line()
	taskDisplay.get_node("Type").text = task.get_line()
	taskDisplay.get_node("Goal").text = task.get_line()
	taskDisplay.get_node("TimeLimit").text = task.get_line()
	taskDisplay.get_node("Ammount").text = task.get_line()
	
	#add the instance as a child of the container
	get_node("PanelContainer").get_node("Container").add_child(taskDisplay)


func autofill():
	var file = File.new()
	if file.file_exists("res://Tasks/" + Folder + "/task0.task"):
		var i = 0
		while(file.file_exists("res://Tasks/" + Folder + "/"+ "task" + str(i) + ".task")):
			if !taskFileNames.has("task" + str(i)):
				taskFileNames.append("task" + str(i))
				#addTask("res://Tasks/" + Folder + "/"+ "task" + str(i) + ".task")
			i += 1
	else:
		return

func _process(delta):
	if main.deleteTaskList:
		if !has_node("PanelContainer/Container/Contain"):
			main.deleteTaskList = false
			hideTasks = false
	
	
	if taskShow:
		main.deleteTaskList = true
		
		if !has_node("PanelContainer/Container/Contain"):
			main.deleteTaskList = false
			hideTasks = false
		else:
			return
		
		taskShow = false
		makeHeader()
		var iterate = 0
		while iterate < taskFileNames.size():
			addTask(str("res://Tasks/" + Folder + "/"+ taskFileNames[iterate] + ".task"))
			iterate += 1