tool
extends Control
var advanced = false


func _process(delta):
	if advanced:
		get_node("Ammount").text = str(main.taskAmmountNeeded)
		get_node("Name").text = main.taskName
		get_node("Type").text = str(main.taskType)
		get_node("TimeLimit").text = str(main.timeLimit)
		get_node("Goal").text = main.taskGoal

	if main.deleteTaskList:
		queue_free()