#written by Seth Ciancio

#Most of this script is just variables that are used in game
#This script is how we send data between nodes & across scenes.

tool #this line means that the code is run in the editor. We do that
#so that other tools can use the variables in main.gd while in the editor.
extends Spatial

signal forceJump

var taskDescription = "none"

#this is where the arrow points
var taskTargetX = 0

var movementEnabled = true

var playerX = 0

var nextLevel = ""

var livesLeft = 3

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

var changeOnDoor = true

var playerCharacter : int = 6

#for the VHS effect
var vhsEffect = 3

#for linkObjects
var sourceNames = [ ]
var linkCodes = [ ]

#for coins
var slowcoin = 0
var coins = 0

#for player
var atTop = false
var atBottom = false

signal taskTimeout

func taskTimeout():
	emit_signal("taskTimeout")

#for deleting entire folders
func recursiveDelete(var folder):
	var dir = Directory.new() #create a directory object
	if !dir.dir_exists(folder): #check if the folder to delete actually exists
		return #if not, then just stop
	
	
	dir.open(folder) #if so, open it
	dir.list_dir_begin(true,false) #begin listing the items in the directory
	var fileName #create a filename variable
	while fileName != "": #loop unitl it's empty
		
		fileName = dir.get_next()
		
		print(fileName)
		
		if dir.current_is_dir():
			if fileName == "":
				dir.change_dir("..")
				dir.remove(folder)
			else:
				recursiveDelete(folder + "/" + fileName)
		elif dir.file_exists(fileName):
			dir.remove(fileName)
		else:
			pass

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

func forceJump(var height):
	print("forcejump")
	emit_signal("forceJump",height,true)

signal updateTaskTarget

func updateTaskTarget():
	emit_signal("updateTaskTarget")
	pass

signal playerDead

func getLevel():
	match levelFolder:
		"LevelOne":
			return "Level1"
		"LevelTwo":
			return "Level2"
		"LevelThree":
			return "Level3"
		"LevelFour":
			return "Level4"


#resets all variables to default levels
func playerDead():
	
	#calls reset tasks function, without success, hiding task pannel, and clearing progress
	resetTasks(false,true,true)
	tasksComplete.clear()
	taskStarted.clear()
	AmmountOfTasksComplete = 0
	coins = 0
	recursiveDelete("user://temp") # deleting everything in the temp folder.
	if livesLeft <= 0:
		playerHealth = 10
		livesLeft = 3
		clearSaved()
		Hud.startLoading("res://UI/mainMenu.tscn")
		return
	livesLeft -= 1
	emit_signal("playerDead")
	var restartLevel = "res://Scenes/Levels/" + getLevel() + "/" + getLevel() + "Outdoor.tscn"
	
	print(restartLevel)
	clearSaved()
	Hud.startLoading(restartLevel,false)
	playerHealth = 10

#deletes temp folder, clearing progress
func clearSaved():
	var dir = Directory.new()
	levelFolder = "na"
	dir.remove("res://temp/")

var jumping = false

func startTask(var updateTaskActive = true):
	taskTargetX = 0
	emit_signal("taskStarted")
	if updateTaskActive:
		taskActive = true

# HERE IS ACTUAL CODE!!
func resetTasks(var success,var hideTaskPannel = true,clearProgress = false):
	taskActive = false
	if success:
		tasksComplete[taskID] = true
		AmmountOfTasksComplete += 1
	elif !clearProgress:
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
				Hud.showMessage("Task completed!","You have successfully completed the task! \nOpen your task menu to start a new one!")
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

signal JumpCheck

func jumpCheck():
	emit_signal("JumpCheck")

var SFXVolume = 0

signal volumeChange

func updateVolume():
	emit_signal("volumeChange")

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