extends Control
#taskpannel script
#Written by Steve Jackson...
#jk it's Seth again.

#these represent all the UI elements that the script has to update
onready var taskName = get_node("CanvasLayer/PanelContainer/HBoxContainer/TaskName")
onready var Goal = get_node("CanvasLayer/PanelContainer/HBoxContainer/Goal")
onready var Ammount = get_node("CanvasLayer/PanelContainer/HBoxContainer/Ammount")
onready var Progress = get_node("CanvasLayer/PanelContainer/HBoxContainer/ProgressBar")
onready var Time = get_node("CanvasLayer/PanelContainer/HBoxContainer/Time")

#timer to count
var timer = Timer.new()

func changeVolume():
	get_node("sfx").set_volume_db(main.SFXVolume)


#called when this thing is loaded in
func _ready():
	
	changeVolume()
	main.connect("volumeChange",self,"changeVolume")
	
	timer.set_wait_time(main.timeLimit)
	self.add_child(timer)
	timer.connect("timeout",self,"_timeout")
	timer.start()
	
	Time.text = str(main.timeLimit)
	Progress.max_value = main.taskAmmountNeeded
	taskName.text = main.taskName
	Goal.text = main.taskGoal
	Ammount.text = str(main.taskAmmountNeeded)
	pass

var prevCollected = 0

#called every frame
func _process(delta):
	Time.text = "Time left: " + str(round(timer.get_time_left())) + " seconds"
	
	if main.taskTargetX == 0:
		get_node("CanvasLayer/arrow").set_visible(false)
		get_node("CanvasLayer/Label").set_visible(true)
	elif main.playerX > main.taskTargetX:
		get_node("CanvasLayer/arrow").set_visible(true)
		get_node("CanvasLayer/Label").set_visible(false)
		get_node("CanvasLayer/arrow").set_flip_h(true)
	else:
		get_node("CanvasLayer/arrow").set_flip_h(false)
		get_node("CanvasLayer/arrow").set_visible(true)
		get_node("CanvasLayer/Label").set_visible(false)
	
	
	if prevCollected != main.taskAmmountCollected:
		prevCollected = main.taskAmmountCollected
		get_node("sfx").play(0)
	Progress.value = main.taskAmmountCollected

func _timeout():
	Hud.showMessage("Task failed!","You ran out of time to complete the task. \nIf you want to, you can start the task again to retry")
	main.resetTasks(false)