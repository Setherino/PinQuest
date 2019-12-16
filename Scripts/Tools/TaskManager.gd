tool
extends Node2D

export(String, "Debug", "LevelOne", "LevelTwo","LevelThree","LevelFour") var Folder
export var taskFileNames :PoolStringArray = ["Template","SecondFile"]
export var save = false
export var deleteTaskList = false

const tasks = preload("res://UI/Task.tscn")

func _ready():
	if !Engine.editor_hint:
		var iterate = 0
		print("out")
		while iterate < taskFileNames.size():
			main.taskFileNames.append("res://Tasks/" + Folder + "/"+ taskFileNames[iterate] + ".task")
			print(main.taskFileNames[iterate])
			iterate += 1
		print("done")

func makeHeader():
	addTask("res://Tasks/Header.task")

func addTask(location:String):
	var task : File = File.new()
	if !task.file_exists(location):
		print("ERROR! " + location + " IS NOT A VALID TASK LOCATION!")
		return
	
	task.open(location,1)
	var taskDisplay = tasks.instance()
	
	taskDisplay.get_node("Name").text = task.get_line()
	taskDisplay.get_node("Type").text = task.get_line()
	taskDisplay.get_node("Goal").text = task.get_line()
	taskDisplay.get_node("TimeLimit").text = task.get_line()
	taskDisplay.get_node("Ammount").text = task.get_line()
	
	get_node("PanelContainer").get_node("Container").add_child(taskDisplay)
	
	

func _process(delta):
	main.deleteTaskList = deleteTaskList
	if save:
		print("saving")
		save = false
		makeHeader()
		var iterate = 0
		while iterate < taskFileNames.size():
			addTask(str("res://Tasks/" + Folder + "/"+ taskFileNames[iterate] + ".task"))
			iterate += 1