tool
extends Spatial

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

#marks whether the current task is complete
var taskID = 0
var taskComplete = false
var taskType = 0
var taskName = "none"
var timeLimit = 0
var taskGoal = "noGoal"
var taskAmmountNeeded = 0

var taskFileNames = [ ]
var tasksComplete = [ ]


var future : File = File.new()

var futureRewards = ["string, please"]

var playerHealth = 10

func _process(delta):
	if Engine.editor_hint:
		return
	if slowcoin > 0:
		slowcoin -= 1
		coins += 1



func _ready():
	if Engine.editor_hint:
		return
	
	futureRewards.clear()
	future.open("res://Rewards/Future.tres",1)
	while (!future.eof_reached()):
		if round(rand_range(1.0,4.0)) == 1:
			futureRewards.push_front(future.get_csv_line("."))
		else:
			futureRewards.push_back(future.get_csv_line("."))