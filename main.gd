#written by Seth Ciancio

#Most of this script is just variables that are used in game
#This script is how we send data between nodes & across scenes.

tool #this line means that the code is run in the editor. We do that
#so that other tools can use the variables in main.gd while in the editor.
extends Spatial

#this is where the arrow points
var taskTargetX = 0

var playerX = 0

var nextLevel = ""

#is the current level an outdoor level
var outdoors = false

var jumpHeight = 0
var forceJump = false

#for deleting the list of tasks
var deleteTaskList = false

#represents whether the player can
#interact with anything right now
var interact = false
var interactWith = "this"

#for linkObjects
var sourceNames = [ ]
var linkCodes = [ ]

#for coins
var slowcoin = 0
var coins = 0

#for player
var atTop = false
var atBottom = false



#task stuff...

#this is for the taskManager
var levelFolder = "na"

#marks whether the current task is complete
var taskID = 0
var taskComplete = false
var taskType = 0
var taskName = "none"
var timeLimit = 0
var taskGoal = "noGoal"
var taskAmmountCollected = 0
var taskActive = false
var taskAmmountNeeded = 0
var AmmountOfTasksComplete = 0
var taskFileNames = [ ]
var tasksComplete = [ ]
var taskStarted = [ ]
#the ammount of tasks/coins for a quest, defined by taskManager
var questTasks = 0
var questCoins = 0

#</task stuff>

var future : File = File.new()

var futureRewards = ["string, please"]

var playerHealth = 10

func startTask():
	emit_signal("taskStarted")
	taskActive = true

# HERE IS ACTUAL CODE!!
func resetTasks(var success,var hideTaskPannel = true):
	taskActive = false
	if success:
		tasksComplete[taskID] = true
		AmmountOfTasksComplete += 1
	else:
		taskStarted[taskID] = false
	if hideTaskPannel:
		Hud.hideTaskPannel()
	taskID = 0
	taskComplete = false
	taskType = 0
	taskName = "none"
	timeLimit = 0
	taskGoal = "noGoal"
	taskAmmountCollected = 0

#is fired when a task starts
signal taskStarted

#runs every frame that main.gd is loaded (which is all of them, lol)
func _process(delta):
	if Engine.editor_hint: #if we're in the editor
		return #stop
	if taskName != "none":
		if taskType == 1:
			if taskAmmountCollected >= taskAmmountNeeded:
				Hud.showMessage("Task completed!","You have successfully completed the task! \nOpepn your task menu to start a new one!")
				resetTasks(true)
				print("YOU COMPLETED THE TASK!!")
		pass
	
	
	#we do it this way because I say so.
	if slowcoin != 0: #of slowcoin > 0,
		if slowcoin > 0:
			slowcoin -= 1
			coins += 1 #and add a coin
		else:
			slowcoin += 1
			coins -= 1 #and subtract a coin
		
		 #reduce it by one
		

func saveGame(var location):
	pass

func _ready():
	if Engine.editor_hint: #if we're in the editor
		return #stop
	
	futureRewards.clear()
	future.open("res://Rewards/Future.tres",1)
	while (!future.eof_reached()):
		if round(rand_range(1.0,4.0)) == 1:
			futureRewards.push_front(future.get_csv_line("."))
		else:
			futureRewards.push_back(future.get_csv_line("."))