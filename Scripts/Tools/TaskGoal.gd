extends Node2D

export var source = "none"

export var byGoal = false

func _process(delta):
	if (main.taskGoal == source) && byGoal:
		main.taskTargetX = position.x


func _ready():
	main.connect("taskStarted",self,"taskStarted")
	get_node("Sprite").set_visible(false)
	if main.taskName == source && !byGoal:
		main.taskTargetX = position.x
	
	if (main.taskGoal == source) && byGoal:
		main.taskTargetX = position.x

func taskStarted():
	if main.taskName == source && !byGoal:
		main.taskTargetX = position.x
	
	if main.taskGoal == source && byGoal:
		main.taskTargetX = position.x