extends Node2D

export var source = "none"

export var byGoal = false

export var any = false

func _process(delta):
	if (main.taskGoal == source) && byGoal:
		main.taskTargetX = position.x


func _ready():
	main.connect("taskStarted",self,"taskStarted")
	main.connect("updateTaskTarget",self,"taskStarted")
	get_node("Sprite").set_visible(false)
	if main.taskName == source && !byGoal:
		main.taskTargetX = position.x
	
	if (main.taskGoal == source) && byGoal:
		main.taskTargetX = position.x

func taskStarted():
	if main.taskName != "none" && any:
		main.taskTargetX = position.x
	
	if main.taskName == source && !byGoal:
		main.taskTargetX = position.x
	
	if main.taskGoal == source && byGoal:
		main.taskTargetX = position.x