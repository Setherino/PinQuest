extends Control

onready var button = get_node("Activate")

var place = 0

func _process(delta):
	if main.taskName != "none":
		button.disabled = true
	else:
		button.disabled = false
	
	if main.deleteTaskList:
		queue_free()

func _on_Activate_pressed():
	main.taskName = get_node("Name").text
	main.taskType = int(get_node("Type").text)
	main.taskGoal = get_node("Goal").text
	main.timeLimit = int(get_node("TimeLimit").text)
	main.taskAmmountNeeded = int(get_node("Ammount").text)
	main.taskID = place
	
	queue_free()
