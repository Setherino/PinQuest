extends Spatial

var jumpHeight = 0
var forceJump = false


#for linkObjects
var sourceNames = [ ]
var linkCodes = [ ]

#for coins
var slowcoin = 0
var coins = 0

#marks whether the current task is complete
var taskComplete = false
var currentTask = "nothing"
var taskType = 0

#these are all the arrays required for the task system
var allTasks = [ ]
var taskTypes = [ ]
var taskTimer = [ ]
var collectionTaskGoal = [ ]
var speakingToGoal = [ ]

var future : File = File.new()

var futureRewards = ["string, please"]

var playerHealth = 10

var toggle = false

func _process(delta):
	if slowcoin > 0:
		slowcoin -= 1
		coins += 1



func _ready():
	futureRewards.clear()
	future.open("res://Rewards/Future.tres",1)
	while (!future.eof_reached()):
		if round(rand_range(1.0,4.0)) == 1:
			futureRewards.push_front(future.get_csv_line("."))
		else:
			futureRewards.push_back(future.get_csv_line("."))